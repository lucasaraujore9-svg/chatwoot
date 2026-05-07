module Api
  module V1
    module Accounts
      module Atende
        class SlaPoliciesController < Api::V1::Accounts::BaseController
          before_action :sla_record, only: %i[show update destroy]

          def index
            authorize Atende::SlaPolicy
            @policies = policy_scope(Atende::SlaPolicy).order(:name)
          end

          def show
            authorize @sla
          end

          def create
            authorize Atende::SlaPolicy
            @sla = Current.account.atende_sla_policies.new(sla_params)
            @sla.save!
            render :show, status: :created
          end

          def update
            authorize @sla
            @sla.update!(sla_params)
            render :show
          end

          def destroy
            authorize @sla
            @sla.destroy!
            head :no_content
          end

          private

          def sla_record
            @sla ||= Current.account.atende_sla_policies.find(params[:id])
          end

          def sla_params
            params.require(:sla_policy).permit(
              :name, :description, :first_response_time_threshold,
              :next_response_time_threshold, :resolution_time_threshold,
              :is_active
            )
          end
        end
      end
    end
  end
end
