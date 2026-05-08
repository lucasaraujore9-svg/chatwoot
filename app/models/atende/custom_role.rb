# == Schema Information
#
# Table name: atende_custom_roles
#
#  id          :bigint           not null, primary key
#  description :text
#  name        :string           not null
#  permissions :jsonb
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :bigint           not null
#
# Indexes
#
#  index_atende_custom_roles_on_account_id_and_name  (account_id,name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#
module Atende
  class CustomRole < ApplicationRecord
    self.table_name = 'atende_custom_roles'

    belongs_to :account

    validates :account_id, :name, presence: true
    validates :name, uniqueness: { scope: :account_id }

    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
