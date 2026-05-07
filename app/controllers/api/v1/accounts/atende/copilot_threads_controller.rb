module Api
  module V1
    module Accounts
      module Atende
        class CopilotThreadsController < Api::V1::Accounts::BaseController
          def show
            thread = Current.account.atende_copilot_threads
                            .find_by(conversation_id: params[:conversation_id])
            if thread
              render json: thread_json(thread)
            else
              head :not_found
            end
          end

          def create
            thread = Current.account.atende_copilot_threads.find_or_initialize_by(
              conversation_id: thread_params[:conversation_id]
            )
            if thread.save
              render json: thread_json(thread), status: :created
            else
              render json: { error: thread.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
          end

          private

          def thread_params
            params.require(:thread).permit(:conversation_id)
          end

          def thread_json(thread)
            {
              id: thread.id,
              conversation_id: thread.conversation_id,
              account_id: thread.account_id,
              created_at: thread.created_at
            }
          end
        end
      end
    end
  end
end
