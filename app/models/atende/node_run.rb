# == Schema Information
#
# Table name: atende_node_runs
#
#  id            :bigint           not null, primary key
#  duration_ms   :integer
#  error_message :text
#  executed_at   :datetime         not null
#  input         :jsonb
#  node_type     :string           not null
#  output        :jsonb
#  status        :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  node_id       :string           not null
#  session_id    :bigint           not null
#
# Indexes
#
#  index_atende_node_runs_on_session_id_and_executed_at  (session_id,executed_at)
#
# Foreign Keys
#
#  fk_rails_...  (session_id => atende_sessions.id) ON DELETE => cascade
#
module Atende
  class NodeRun < ApplicationRecord
    self.table_name = 'atende_node_runs'

    belongs_to :session, class_name: 'Atende::Session'

    validates :node_id, :node_type, :status, :executed_at, presence: true
  end
end
