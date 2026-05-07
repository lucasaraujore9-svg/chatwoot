module Atende
  class AgentPolicy < ApplicationPolicy
    def index?
      account_user.present?
    end

    def show?
      account_user.present? && record.account_id == account.id
    end

    def create?
      account_user&.administrator?
    end

    def update?
      account_user&.administrator? && record.account_id == account.id
    end

    def destroy?
      update?
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(account_id: account.id)
      end
    end
  end
end
