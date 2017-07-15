class Giftcard < ActiveRecord::Base
	validates :code, uniqueness: true, length: { is: 16 }
	has_many :giftcardRedemptions
end