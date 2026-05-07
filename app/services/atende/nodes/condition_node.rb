module Atende
  module Nodes
    class ConditionNode < BaseNode
      def execute
        conditions = data['conditions'] || []
        match_type = data['match_type'] || 'all'
        evaluator = Atende::ExpressionEvaluator.new(session.variables || {})
        matched = evaluator.evaluate(conditions.map(&:with_indifferent_access), match_type: match_type)
        next_id = matched ? data['next_true'] : data['next_false']
        { next_node_id: next_id, output: { matched: matched } }
      end
    end
  end
end
