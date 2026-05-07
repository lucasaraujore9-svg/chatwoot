module Api
  module V1
    module Accounts
      module Atende
        class FlowsController < Api::V1::Accounts::BaseController
          before_action :flow, only: [:show, :update, :destroy, :publish, :unpublish]

          def index
            authorize Atende::Flow
            @flows = policy_scope(Atende::Flow).order(updated_at: :desc).page(params[:page])
          end

          def show
            authorize @flow
          end

          def create
            authorize Atende::Flow
            @flow = Current.account.atende_flows.new(flow_params)
            authorize @flow
            @flow.save!
            render :show, status: :created
          end

          def update
            authorize @flow
            @flow.update!(flow_params)
            render :show
          end

          def destroy
            authorize @flow
            @flow.destroy!
            head :ok
          end

          def publish
            authorize @flow, :publish?
            @flow.update!(status: :published, is_published: true)
            render :show
          end

          def unpublish
            authorize @flow, :unpublish?
            @flow.update!(status: :draft, is_published: false)
            render :show
          end

          private

          def flow
            @flow ||= Current.account.atende_flows.find(params[:id])
          end

          def flow_params
            params.require(:flow).permit(:name, :description, graph: {})
          end
        end
      end
    end
  end
end
