module Api
  module V1
    module Accounts
      module Atende
        class AuditLogsController < Api::V1::Accounts::BaseController
          def index
            authorize :audit_log, :index?
            @logs = Audited::Audit.where(associated_type: 'Account', associated_id: Current.account.id)
                                  .order(created_at: :desc)
                                  .page(params[:page])
          end

          def show
            authorize :audit_log, :show?
            @log = Audited::Audit.find(params[:id])
          end
        end
      end
    end
  end
end
