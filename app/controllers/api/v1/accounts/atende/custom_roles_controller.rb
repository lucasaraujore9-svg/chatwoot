module Api
  module V1
    module Accounts
      module Atende
        class CustomRolesController < Api::V1::Accounts::BaseController
          before_action :role_record, only: %i[show update destroy]

          def index
            authorize Atende::CustomRole
            @roles = policy_scope(Atende::CustomRole).order(:name)
          end

          def show
            authorize @role
          end

          def create
            authorize Atende::CustomRole
            @role = Current.account.atende_custom_roles.new(role_params)
            @role.save!
            render :show, status: :created
          end

          def update
            authorize @role
            @role.update!(role_params)
            render :show
          end

          def destroy
            authorize @role
            @role.destroy!
            head :no_content
          end

          private

          def role_record
            @role ||= Current.account.atende_custom_roles.find(params[:id])
          end

          def role_params
            params.require(:custom_role).permit(:name, :description, permissions: [])
          end
        end
      end
    end
  end
end
