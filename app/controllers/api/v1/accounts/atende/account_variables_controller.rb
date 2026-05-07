module Api
  module V1
    module Accounts
      module Atende
        class AccountVariablesController < Api::V1::Accounts::BaseController
          before_action :variable, only: [:show, :update, :destroy]

          def index
            authorize Atende::AccountVariable
            @variables = policy_scope(Atende::AccountVariable).order(:key)
          end

          def show
            authorize @variable
          end

          def create
            authorize Atende::AccountVariable
            @variable = Current.account.atende_account_variables.new(variable_params)
            authorize @variable
            @variable.save!
            render :show, status: :created
          end

          def update
            authorize @variable
            @variable.update!(variable_params)
            render :show
          end

          def destroy
            authorize @variable
            @variable.destroy!
            head :ok
          end

          private

          def variable
            @variable ||= Current.account.atende_account_variables.find(params[:id])
          end

          def variable_params
            params.require(:account_variable).permit(:key, :value_encrypted, :var_type, :is_secret)
          end
        end
      end
    end
  end
end
