class Checkin < ActiveRecord::Base

  belongs_to :restaurant
  belongs_to :user

  validates_presence_of :restaurant
  validates_presence_of :user

end
