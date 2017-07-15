class AddSuggesterInfoToRestaurant < ActiveRecord::Migration
  def change
    add_column :restaurants , :suggester_email, :string
    add_column :restaurants , :suggester_phone, :string
  end
end
