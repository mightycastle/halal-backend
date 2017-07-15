class AddGemHunterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gem_hunter, :boolean, :default => false
  end
end
