class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :amount
      t.integer :plan_type_id

      t.timestamps
    end
  end
end
