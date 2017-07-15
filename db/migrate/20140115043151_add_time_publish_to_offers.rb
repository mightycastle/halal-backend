class AddTimePublishToOffers < ActiveRecord::Migration
  def change
    add_column :offers, :date_publish, :string
    add_column :offers, :time_publish, :integer
  end
end
