module Atende
  class CopilotThreadPolicy < ApplicationPolicy
    def show?   = account_user.present? && record.account_id == account.id
    def create? = account_user.present?

    class Scope < ApplicationPolicy::Scope
      def resolve = scope.where(account_id: account.id)
    end
  end
end
