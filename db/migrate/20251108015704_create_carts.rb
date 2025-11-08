class CreateCarts < ActiveRecord::Migration[7.1]
  def change
    create_table :carts do |t|
      t.string :status
      t.datetime :last_interaction_at
      t.datetime :abandoned_at

      t.timestamps
    end
  end
end
