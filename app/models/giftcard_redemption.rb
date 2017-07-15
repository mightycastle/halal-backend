class GiftcardRedemption < ActiveRecord::Base
	belongs_to :giftcard
	belongs_to :restaurant
	
	validates_presence_of :restaurant
	validates_presence_of :giftcard
end