module Atende
  module AgentTools
    class BaseTool
      attr_reader :session

      def self.schema
        raise NotImplementedError
      end

      def initialize(session)
        @session = session
      end

      def call(args)
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
    end
  end
end
