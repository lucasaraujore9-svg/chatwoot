module Api
  module V1
    module Accounts
      module Atende
        class QrcodeInboxesController < Api::V1::Accounts::BaseController
          before_action :find_channel, only: [:qr_code, :disconnect, :destroy]

          def create
            channel = Channel::QrcodeWhatsapp.new(account: Current.account)
            channel.proxy_url = params[:proxy_url].presence

            if channel.save
              inbox = Inbox.create!(
                account: Current.account,
                channel: channel,
                name: params[:name].presence || 'WhatsApp QrCode',
                channel_type: 'Channel::QrcodeWhatsapp'
              )
              qr = begin
                channel.refresh_qr_code
              rescue StandardError
                nil
              end
              render json: { inbox_id: inbox.id, channel_id: channel.id, qr_code: qr }, status: :created
            else
              render json: { error: channel.errors.full_messages.join(', ') }, status: :unprocessable_entity
            end
          end

          def qr_code
            qr = @channel.refresh_qr_code
            render json: { qr_code: qr, status: @channel.status }
          rescue StandardError => e
            render json: { error: e.message }, status: :service_unavailable
          end

          def disconnect
            begin
              Atende::Gowa::Client.new(session_id: @channel.gowa_session_id).logout
            rescue StandardError
              nil
            end
            @channel.update(status: 'disconnected', qr_code_data: nil)
            head :no_content
          end

          def destroy
            begin
              Atende::Gowa::Client.new(session_id: @channel.gowa_session_id).logout
            rescue StandardError
              nil
            end
            @channel.inbox.destroy!
            head :no_content
          end

          private

          def find_channel
            @channel = Current.account.inboxes
                              .joins('INNER JOIN channel_qrcode_whatsapps ON channel_qrcode_whatsapps.id = inboxes.channel_id')
                              .where(channel_type: 'Channel::QrcodeWhatsapp')
                              .find(params[:id])
                              .channel
          rescue ActiveRecord::RecordNotFound
            head :not_found
          end
        end
      end
    end
  end
end
