class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email , :null => false, :default => ""
      t.string :username
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :phone
      t.string :address
      t.string :avatar
      t.string :im
      t.string :status, :default => "unverified"

      t.timestamps
    end
  end
end
