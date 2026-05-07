class AuditLogPolicy < ApplicationPolicy
  def index? = account_user&.administrator?
  def show?  = account_user&.administrator?
end
