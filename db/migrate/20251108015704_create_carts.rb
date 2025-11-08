class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.string :status, null: false, default: 'active'
      t.datetime :last_interaction_at
      t.datetime :abandoned_at

      t.timestamps
    end

    add_index :carts, :status
    add_index :carts, :abandoned_at
  end
end
