class AddImageToOffer < ActiveRecord::Migration
  def change
    add_column :offers, :image_uid, :string
    add_column :offers, :image_name, :string
  end
end
