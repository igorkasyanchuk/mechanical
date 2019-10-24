class CreateMechanicalMechanicalStores < ActiveRecord::Migration[6.0]
  def change
    create_table :mechanical_mechanical_stores do |t|
      t.integer :mechanicalable_id
      t.string :mechanicalable_type

      t.integer :____user_id
      t.string :____model_type
      t.jsonb :____data, default: {}
      t.timestamps
    end

    add_index :mechanical_mechanical_stores, :____user_id
    add_index :mechanical_mechanical_stores, :____model_type
    add_index :mechanical_mechanical_stores, [:mechanicalable_id, :mechanicalable_type], name: :____mmidtype
  end
end
