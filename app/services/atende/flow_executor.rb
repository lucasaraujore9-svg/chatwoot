module Atende
  class FlowExecutor
    MAX_STEPS = 50

    NODE_EXECUTORS = {
      'start' => Atende::Nodes::MessageNode,
      'message' => Atende::Nodes::MessageNode,
      'question' => Atende::Nodes::QuestionNode,
      'condition' => Atende::Nodes::ConditionNode,
      'add_label' => Atende::Nodes::AddLabelNode,
      'transfer_to_human' => Atende::Nodes::TransferToHumanNode,
      'transfer_to_team' => Atende::Nodes::TransferToTeamNode,
      'set_variable' => Atende::Nodes::SetVariableNode,
      'webhook' => Atende::Nodes::WebhookNode,
      'update_contact_attr' => Atende::Nodes::UpdateContactAttrNode,
      'update_conversation_attr' => Atende::Nodes::UpdateConversationAttrNode,
      'menu' => Atende::Nodes::MenuNode,
      'switch' => Atende::Nodes::SwitchNode,
      'end' => Atende::Nodes::EndNode
    }.freeze

    def initialize(session)
      @session = session
    end

    # Entry point when a new message arrives in a flow session
    def resume(incoming_message_content = nil)
      return unless @session.active?

      store_incoming_reply(incoming_message_content) if incoming_message_content.present?

      run_from_current_node
    rescue StandardError => e
      Rails.logger.error "[Atende::FlowExecutor] session=#{@session.id} error=#{e.message}"
      @session.update!(status: :failed)
      raise
    end

    # Start a brand-new session from the first node of the flow
    def self.start(session)
      flow = session.flow
      graph = flow.graph.with_indifferent_access
      start_node = find_start_node(graph['nodes'] || [])
      return unless start_node

      session.update!(current_node_id: start_node['id'])
      new(session).resume
    end

    private

    def run_from_current_node
      steps = 0
      loop do
        steps += 1
        raise "Max steps (#{MAX_STEPS}) exceeded for session #{@session.id}" if steps > MAX_STEPS
        break unless @session.reload.active?

        node = current_node
        break unless node

        result = execute_node(node)
        break if result[:wait_for_input]
        break unless result[:next_node_id]

        @session.update!(current_node_id: result[:next_node_id])
      end
    end

    def current_node
      graph = @session.flow.graph.with_indifferent_access
      (graph['nodes'] || []).find { |n| n['id'] == @session.current_node_id }
    end

    def execute_node(node)
      node_type = node.dig('data', 'type') || node['type']
      executor_class = NODE_EXECUTORS[node_type.to_s]
      raise "Unknown node type: #{node_type}" unless executor_class

      started_at = Time.current
      result = executor_class.new(@session, node).execute

      Atende::NodeRun.create!(
        session_id: @session.id,
        node_id: node['id'],
        node_type: node_type,
        status: 'success',
        output: result[:output] || {},
        duration_ms: ((Time.current - started_at) * 1000).to_i,
        executed_at: started_at
      )

      handle_wait_for_input(result) if result[:wait_for_input]

      result
    rescue StandardError => e
      Atende::NodeRun.create!(
        session_id: @session.id,
        node_id: node['id'],
        node_type: node.dig('data', 'type') || node['type'],
        status: 'error',
        error_message: e.message,
        executed_at: Time.current
      )
      raise
    end

    def handle_wait_for_input(result)
      variable = result[:variable]
      return unless variable

      # Store the pending variable name so we know where to store the next reply
      new_vars = (@session.variables || {}).merge('_waiting_for' => variable)

      new_vars['_menu_options'] = result[:menu_options] if result[:menu_options]

      @session.update!(variables: new_vars)
    end

    def store_incoming_reply(content)
      vars = @session.variables || {}
      waiting_for = vars['_waiting_for']
      return unless waiting_for

      menu_options = vars['_menu_options']
      value = if menu_options
                choice_idx = content.to_i - 1
                opt = menu_options[choice_idx]
                opt ? opt['next'] : nil
              else
                content
              end

      new_vars = vars.except('_waiting_for', '_menu_options')
      new_vars[waiting_for] = value

      # For menu nodes, advance to the chosen branch
      if menu_options && value
        @session.update!(variables: new_vars, current_node_id: value)
      else
        @session.update!(variables: new_vars)
      end
    end

    def self.find_start_node(nodes)
      nodes.find { |n| (n.dig('data', 'type') || n['type']).to_s == 'start' } || nodes.first
    end
  end
end
