class AddImageTypeToAdminPhotos < ActiveRecord::Migration
  def change
    add_column :admin_photos, :image_type, :boolean, :default => true
  end
end
