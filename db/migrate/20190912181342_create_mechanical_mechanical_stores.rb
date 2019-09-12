class CreateMechanicalMechanicalStores < ActiveRecord::Migration[6.0]
  def change
    create_table :mechanical_mechanical_stores do |t|
      t.integer :user_id
      t.string :type
      t.string :title
      t.jsonb :data

      t.timestamps
    end
  end
end
