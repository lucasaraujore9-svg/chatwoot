module Atende
  class NodeRun < ApplicationRecord
    self.table_name = 'atende_node_runs'

    belongs_to :session, class_name: 'Atende::Session'

    validates :node_id, :node_type, :status, :executed_at, presence: true
  end
end
