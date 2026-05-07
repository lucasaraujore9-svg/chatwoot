class CreateAtendeLlmCredentials < ActiveRecord::Migration[7.0]
  def change
    create_table :atende_llm_credentials do |t|
      t.bigint :account_id, null: false
      t.string :provider, null: false
      t.string :label, null: false
      t.text :api_key_encrypted
      t.jsonb :extra_config, default: {}
      t.boolean :is_default, default: false, null: false
      t.datetime :last_validated_at
      t.string :validation_status, default: 'unknown', null: false
      t.timestamps
    end

    add_index :atende_llm_credentials, [:account_id, :provider]
    add_index :atende_llm_credentials, [:account_id, :is_default],
              unique: true,
              where: 'is_default = TRUE',
              name: 'index_atende_llm_credentials_one_default_per_account'
    add_foreign_key :atende_llm_credentials, :accounts, on_delete: :cascade
  end
end
