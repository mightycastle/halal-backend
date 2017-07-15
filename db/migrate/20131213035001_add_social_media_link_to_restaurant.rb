class AddSocialMediaLinkToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants, :facebook_link, :string
    add_column :restaurants, :twitter_link, :string
    add_column :restaurants, :pinterest_link, :string
  end
end
