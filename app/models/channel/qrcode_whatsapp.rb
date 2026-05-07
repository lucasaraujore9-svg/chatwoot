class Channel::QrcodeWhatsapp < ApplicationRecord
  self.table_name = 'channel_qrcode_whatsapps'

  include Channelable

  belongs_to :account

  STATUSES = %w[disconnected qr_pending connected failed].freeze

  validates :gowa_session_id, presence: true, uniqueness: true
  validates :webhook_secret, presence: true, uniqueness: true
  validates :status, inclusion: { in: STATUSES }

  before_validation :generate_webhook_secret, on: :create
  before_validation :generate_session_id, on: :create

  def name
    'QrCode WhatsApp'
  end

  def connected?
    status == 'connected'
  end

  def gowa_client
    @gowa_client ||= Atende::Gowa::Client.new(session_id: gowa_session_id)
  end

  def send_message(message)
    return unless connected?

    gowa_client.send_message(
      phone: message.conversation.meta.dig(:sender, :phone_number),
      message: message.content
    )
  end

  def refresh_qr_code
    update(status: 'qr_pending')
    response = gowa_client.generate_qr
    update(qr_code_data: response['qrCode'])
    response['qrCode']
  end

  private

  def generate_webhook_secret
    self.webhook_secret ||= SecureRandom.hex(32)
  end

  def generate_session_id
    self.gowa_session_id ||= "atende_#{account_id}_#{SecureRandom.hex(8)}"
  end
end
