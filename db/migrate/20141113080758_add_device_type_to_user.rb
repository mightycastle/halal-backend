class AddDeviceTypeToUser < ActiveRecord::Migration
  def up
    add_column :users, :device_token, :string
    add_column :users, :device_type, :integer
    add_column :users, :fb_access_token, :string
    add_column :users, :avatar_fb_url, :string
  end
  def down
    remove_column :users, :device_token
    remove_column :users, :device_type
    remove_column :users, :fb_access_token
    remove_column :users, :avatar_fb_url
  end
end
