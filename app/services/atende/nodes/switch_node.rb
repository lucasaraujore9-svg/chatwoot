module Atende
  module Nodes
    # Routes to different branches based on variable value.
    # cases: [{ value: 'X', next: 'node_id' }], default_next: 'node_id'
    class SwitchNode < BaseNode
      def execute
        variable_key = data['variable'].to_s
        actual_value = (session.variables || {})[variable_key].to_s
        cases = data['cases'] || []
        matched_case = cases.find { |c| c['value'].to_s == actual_value }
        next_id = matched_case ? matched_case['next'] : data['default_next']
        { next_node_id: next_id, output: { matched_value: actual_value } }
      end
    end
  end
end
