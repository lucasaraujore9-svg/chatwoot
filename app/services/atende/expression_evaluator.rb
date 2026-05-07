module Atende
  # Evaluates simple boolean conditions from flow condition nodes.
  # Supports operators: eq, neq, contains, not_contains, starts_with, ends_with,
  #                     gt, lt, gte, lte, is_empty, is_not_empty
  class ExpressionEvaluator
    OPERATORS = %w[eq neq contains not_contains starts_with ends_with gt lt gte lte is_empty is_not_empty].freeze

    def initialize(variables = {})
      @variables = variables.with_indifferent_access
    end

    # conditions: array of { variable:, operator:, value: }
    # match_type: 'all' | 'any'
    def evaluate(conditions, match_type: 'all')
      results = conditions.map { |c| evaluate_condition(c) }
      match_type == 'all' ? results.all? : results.any?
    end

    private

    def evaluate_condition(condition)
      operator = condition[:operator].to_s
      variable_key = condition[:variable].to_s
      expected = condition[:value].to_s

      actual = resolve_variable(variable_key).to_s

      case operator
      when 'eq'           then actual == expected
      when 'neq'          then actual != expected
      when 'contains'     then actual.include?(expected)
      when 'not_contains' then !actual.include?(expected)
      when 'starts_with'  then actual.start_with?(expected)
      when 'ends_with'    then actual.end_with?(expected)
      when 'gt'           then actual.to_f > expected.to_f
      when 'lt'           then actual.to_f < expected.to_f
      when 'gte'          then actual.to_f >= expected.to_f
      when 'lte'          then actual.to_f <= expected.to_f
      when 'is_empty'     then actual.blank?
      when 'is_not_empty' then actual.present?
      else false
      end
    rescue StandardError
      false
    end

    def resolve_variable(key)
      parts = key.split('.')
      value = @variables
      parts.each do |part|
        value = value.is_a?(Hash) ? value[part] : nil
        break if value.nil?
      end
      value
    end
  end
end
