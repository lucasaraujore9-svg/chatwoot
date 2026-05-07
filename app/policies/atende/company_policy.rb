module Atende
  class CompanyPolicy < ApplicationPolicy
    def index?   = account_user.present?
    def show?    = account_user.present? && record.account_id == account.id
    def create?  = account_user&.administrator?
    def update?  = show? && account_user&.administrator?
    def destroy? = update?

    class Scope < ApplicationPolicy::Scope
      def resolve = scope.where(account_id: account.id)
    end
  end
end
