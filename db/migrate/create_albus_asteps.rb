class CreateAlbusAsteps < ActiveRecord::Migration[7.1]
  def change
    create_table :asteps do |t|
      t.string :step_definition_kind, null: false
      t.references :next_step, null: true, foreign_key: { to_table: :asteps }, index: { unique: true }
      t.string :record_type, null: false
      t.bigint :record_id, null: false
      t.integer :index, null: false
      t.boolean :completed, null: false, default: false
      t.boolean :locked, null: false, default: false
      t.jsonb :data

      t.timestamps
    end
  end
end
