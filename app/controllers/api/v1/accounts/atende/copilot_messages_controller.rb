module Api
  module V1
    module Accounts
      module Atende
        class CopilotMessagesController < Api::V1::Accounts::BaseController
          before_action :find_thread

          def index
            messages = @thread.atende_copilot_messages
                              .order(created_at: :asc)
                              .last(50)
            render json: { messages: messages.map { |m| message_json(m) } }
          end

          def create
            Atende::CopilotJob.perform_later(
              thread_id: @thread.id,
              account_id: Current.account.id,
              user_message: message_params[:content]
            )
            head :accepted
          end

          private

          def find_thread
            @thread = Current.account.atende_copilot_threads.find(params[:copilot_thread_id])
          rescue ActiveRecord::RecordNotFound
            head :not_found
          end

          def message_params
            params.require(:message).permit(:content)
          end

          def message_json(message)
            {
              id: message.id,
              role: message.role,
              content: message.content,
              created_at: message.created_at
            }
          end
        end
      end
    end
  end
end
