module Atende
  class CustomRolePolicy < ApplicationPolicy
    def index?   = account_user&.administrator?
    def show?    = account_user&.administrator? && record.account_id == account.id
    def create?  = account_user&.administrator?
    def update?  = show?
    def destroy? = show?

    class Scope < ApplicationPolicy::Scope
      def resolve = scope.where(account_id: account.id)
    end
  end
end
