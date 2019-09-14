class CreateMechanicalMechanicalStores < ActiveRecord::Migration[6.0]
  def change
    create_table :mechanical_mechanical_stores do |t|
      t.integer :user_id

      t.integer :mechanicalable_id
      t.string :mechanicalable_type

      t.string :__model_type
      t.jsonb :__data, default: {}
      t.timestamps
    end

    add_index :mechanical_mechanical_stores, :user_id
    add_index :mechanical_mechanical_stores, :__model_type
    add_index :mechanical_mechanical_stores, [:mechanicalable_id, :mechanicalable_type], name: :__mmidtype
  end
end
