class CreateChannelQrcodeWhatsapps < ActiveRecord::Migration[7.0]
  def change
    create_table :channel_qrcode_whatsapps do |t|
      t.bigint :account_id, null: false
      t.string :phone_number
      t.string :gowa_session_id, null: false
      t.string :proxy_url
      t.string :status, default: 'disconnected', null: false
      t.text :qr_code_data
      t.string :webhook_secret, null: false
      t.timestamps
    end

    add_index :channel_qrcode_whatsapps, :gowa_session_id, unique: true
    add_index :channel_qrcode_whatsapps, :webhook_secret, unique: true
    add_index :channel_qrcode_whatsapps, :account_id
    add_foreign_key :channel_qrcode_whatsapps, :accounts, on_delete: :cascade
  end
end
