class Webhooks::GowaController < ApplicationController
  skip_before_action :verify_authenticity_token

  def receive
    channel = Channel::QrcodeWhatsapp.find_by(webhook_secret: params[:secret])
    return head :unauthorized unless channel
    return head :unauthorized unless valid_signature?(channel)

    process_event(channel, payload)
    head :ok
  end

  private

  def payload
    @payload ||= JSON.parse(request.body.read)
  rescue JSON::ParserError
    {}
  end

  def valid_signature?(channel)
    signature = request.headers['X-Webhook-Signature']
    return true if signature.blank?

    expected = OpenSSL::HMAC.hexdigest('SHA256', channel.webhook_secret, request.raw_post)
    ActiveSupport::SecurityUtils.secure_compare(signature, expected)
  end

  def process_event(channel, payload)
    event_type = payload['type']
    case event_type
    when 'message'
      Atende::Gowa::ProcessIncomingMessageJob.perform_later(channel.id, payload)
    when 'status'
      handle_status_update(channel, payload)
    when 'qr'
      channel.update(qr_code_data: payload['qr'], status: 'qr_pending')
    end
  end

  def handle_status_update(channel, payload)
    new_status = payload['status']
    channel.update(status: new_status) if Channel::QrcodeWhatsapp::STATUSES.include?(new_status)
  end
end
