class CreateMechanicalMechanicalStores < ActiveRecord::Migration[6.0]
  def change
    create_table :mechanical_mechanical_stores do |t|
      t.integer :mechanicalable_id
      t.string :mechanicalable_type

      t.integer :mechanical_user_id
      t.string :mechanical_model_type
      t.jsonb :mechanical_data, default: {}
      t.timestamps
    end

    add_index :mechanical_mechanical_stores, :mechanical_user_id
    add_index :mechanical_mechanical_stores, :mechanical_model_type
    add_index :mechanical_mechanical_stores, [:mechanicalable_id, :mechanicalable_type], name: :____mmidtype
  end
end
