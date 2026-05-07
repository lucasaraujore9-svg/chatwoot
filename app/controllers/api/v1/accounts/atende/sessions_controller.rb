module Api
  module V1
    module Accounts
      module Atende
        class SessionsController < Api::V1::Accounts::BaseController
          before_action :session_record, only: [:show]

          def index
            authorize Atende::Session
            @sessions = policy_scope(Atende::Session)
                        .order(started_at: :desc)
                        .page(params[:page])
            @sessions = @sessions.where(status: params[:status]) if params[:status].present?
            @sessions = @sessions.where(kind: params[:kind]) if params[:kind].present?
          end

          def show
            authorize @session
          end

          private

          def session_record
            @session ||= Current.account.atende_sessions.find(params[:id])
          end
        end
      end
    end
  end
end
