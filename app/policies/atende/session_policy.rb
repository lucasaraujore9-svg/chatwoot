module Atende
  class SessionPolicy < ApplicationPolicy
    def index?
      account_user.present?
    end

    def show?
      account_user.present? && record.account_id == account.id
    end

    def create?
      false
    end

    def update?
      false
    end

    def destroy?
      false
    end

    class Scope < ApplicationPolicy::Scope
      def resolve
        scope.where(account_id: account.id)
      end
    end
  end
end
