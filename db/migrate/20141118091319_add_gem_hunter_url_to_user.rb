class AddGemHunterUrlToUser < ActiveRecord::Migration
  def up
    add_column :users, :gem_hunter_wordpress_url, :string
  end
  def down
    remove_column :users, :gem_hunter_wordpress_url
  end
end
