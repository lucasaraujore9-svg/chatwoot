class CreateChannelQrcodeWhatsapps < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_qrcode_whatsapps do |t|
      t.references :account, null: false, foreign_key: { on_delete: :cascade }
      t.string :phone_number
      t.string :gowa_session_id, null: false, default: ''
      t.string :proxy_url
      t.string :status, null: false, default: 'disconnected'
      t.text :qr_code_data
      t.string :webhook_secret, null: false, default: ''
      t.timestamps
    end

    add_index :channel_qrcode_whatsapps, :gowa_session_id, unique: true
    add_index :channel_qrcode_whatsapps, :webhook_secret, unique: true
  end
end
