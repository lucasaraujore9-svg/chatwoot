module Api
  module V1
    module Accounts
      module Atende
        class AgentCapacityPoliciesController < Api::V1::Accounts::BaseController
          before_action :policy_record, only: %i[show update destroy]

          def index
            authorize Atende::AgentCapacityPolicy
            @policies = policy_scope(Atende::AgentCapacityPolicy)
          end

          def show
            authorize @policy
          end

          def create
            authorize Atende::AgentCapacityPolicy
            @policy = Current.account.atende_agent_capacity_policies.new(policy_params)
            @policy.save!
            render :show, status: :created
          end

          def update
            authorize @policy
            @policy.update!(policy_params)
            render :show
          end

          def destroy
            authorize @policy
            @policy.destroy!
            head :no_content
          end

          private

          def policy_record
            @policy ||= Current.account.atende_agent_capacity_policies.find(params[:id])
          end

          def policy_params
            params.require(:agent_capacity_policy).permit(:agent_id, :max_conversations, :is_active)
          end
        end
      end
    end
  end
end
