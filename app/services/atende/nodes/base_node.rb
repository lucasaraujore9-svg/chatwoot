module Atende
  module Nodes
    class BaseNode
      attr_reader :session, :node, :interpolator

      def initialize(session, node)
        @session = session
        @node = node
        @interpolator = Atende::Interpolator.new(session.variables || {})
      end

      # Returns { next_node_id:, output: {} } or raises
      def execute
        raise NotImplementedError
      end

      private

      def conversation
        @conversation ||= session.conversation
      end

      def account
        @account ||= session.account
      end

      def contact
        @contact ||= session.contact
      end

      def data
        node['data'] || {}
      end

      def interp(text)
        interpolator.interpolate(text.to_s)
      end
    end
  end
end
