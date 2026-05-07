module AtendeAccountable
  extend ActiveSupport::Concern

  included do
    has_many :atende_flows, class_name: 'Atende::Flow', dependent: :destroy
    has_many :atende_sessions, class_name: 'Atende::Session', dependent: :destroy
    has_many :atende_account_variables, class_name: 'Atende::AccountVariable', dependent: :destroy
    has_many :atende_inbox_assignments, class_name: 'Atende::InboxAssignment', dependent: :destroy
    has_many :atende_llm_credentials, class_name: 'Atende::LlmCredential', dependent: :destroy
    has_many :atende_agents, class_name: 'Atende::Agent', dependent: :destroy
    has_many :atende_agent_capacity_policies, class_name: 'Atende::AgentCapacityPolicy', dependent: :destroy
    has_many :atende_custom_roles, class_name: 'Atende::CustomRole', dependent: :destroy
    has_many :atende_companies, class_name: 'Atende::Company', dependent: :destroy
    has_many :atende_sla_policies, class_name: 'Atende::SlaPolicy', dependent: :destroy
    has_many :atende_copilot_threads, class_name: 'Atende::CopilotThread', dependent: :destroy
  end
end
