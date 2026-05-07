module Atende
  module Nodes
    class SetVariableNode < BaseNode
      def execute
        key = data['key'].to_s
        value = interp(data['value'].to_s)
        new_vars = (session.variables || {}).merge(key => value)
        session.update!(variables: new_vars)
        { next_node_id: data['next'], output: { key: key, value: value } }
      end
    end
  end
end
