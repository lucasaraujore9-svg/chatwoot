# == Schema Information
#
# Table name: atende_account_variables
#
#  id              :bigint           not null, primary key
#  is_secret       :boolean          default(FALSE), not null
#  key             :string           not null
#  value_encrypted :text
#  var_type        :string           default("string"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :bigint           not null
#
# Indexes
#
#  index_atende_account_variables_on_account_id_and_key  (account_id,key) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (account_id => accounts.id) ON DELETE => cascade
#
module Atende
  class AccountVariable < ApplicationRecord
    self.table_name = 'atende_account_variables'

    belongs_to :account

    validates :key, presence: true, format: { with: /\A[a-z][a-z0-9_]*\z/, message: 'must be snake_case (lowercase letters, digits, underscores)' }
    validates :key, uniqueness: { scope: :account_id }
    validates :var_type, inclusion: { in: %w[string number boolean] }

    scope :for_account, ->(account_id) { where(account_id: account_id) }
  end
end
