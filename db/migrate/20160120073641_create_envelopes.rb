class CreateEnvelopes < ActiveRecord::Migration
  def change
    create_table :envelopes do |t|
      t.boolean  :active, default: true, null: false
      t.string   :curator
      t.string   :do_not_distribute
      t.string   :doc_id, null: false
      t.string   :doc_type, null: false
      t.string   :doc_version, null: false
      t.text     :keys, array: true, default: []
      t.string   :owner
      t.string   :payload_locator
      t.integer  :payload_placement, null: false
      t.text     :payload_schema, array: true, default: []
      t.string   :payload_schema_format
      t.string   :payload_schema_locator
      t.string   :publishing_node, null: false
      t.json     :raw_data
      t.text     :replaces, array: true, default: []
      t.text     :resource_data
      t.string   :resource_data_type, null: false
      t.string   :resource_locator, null: false
      t.integer  :resource_ttl
      t.string   :signature
      t.text     :signature_key_location, array: true, default: []
      t.string   :signer
      t.string   :signing_method
      t.string   :submission_attribution
      t.string   :submission_tos, null: false
      t.string   :submitter, null: false
      t.datetime :submitter_timestamp
      t.datetime :submitter_ttl
      t.integer  :submitter_type, null: false
      t.integer  :weight

      t.timestamps null: false

      t.index :doc_id, unique: true
    end
  end
end
