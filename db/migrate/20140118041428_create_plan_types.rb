class CreatePlanTypes < ActiveRecord::Migration
  def change
    create_table :plan_types do |t|
      t.string :name
      t.integer :number_of_months

      t.timestamps
    end
  end
end
