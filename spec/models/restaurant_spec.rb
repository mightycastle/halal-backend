require "rails_helper"

describe Restaurant do
  context "association" do
    it { Restaurant.reflect_on_association(:user).macro.should  eq(:belongs_to) }
    it { Restaurant.reflect_on_association(:photos).macro.should  eq(:has_many) }
    it { Restaurant.reflect_on_association(:schedules).macro.should  eq(:has_many) }
    it { Restaurant.reflect_on_association(:reviews).macro.should  eq(:has_many) }
    it { Restaurant.reflect_on_association(:offers).macro.should  eq(:has_many) }
    it { Restaurant.reflect_on_association(:filters).macro.should  eq(:has_and_belongs_to_many) }
    it { Restaurant.reflect_on_association(:filter_types).macro.should  eq(:has_and_belongs_to_many) }
    it { Restaurant.reflect_on_association(:favourites).macro.should  eq(:has_many) }
    it { Restaurant.reflect_on_association(:menus).macro.should  eq(:has_many)  }
  end

  context "validate" do
    before :each do
      @restaurant_params = {
        name: Faker::Name.name,
        slug: "#{Faker::Name.name}#{Time.now.to_i}",
        phone: '123456789',
        email: Faker::Internet.email
      }    
    end

    it "save success with valid params" do
      restaurant = Restaurant.new(@restaurant_params)
      expect(restaurant.save!).to eq true
    end

    it "is invalid without a name" do
      @restaurant_params.delete(:name)
      expect(Restaurant.new(@restaurant_params)).not_to be_valid
    end

    it "is invalid when update without a slug, or existed slug" do
      restaurant1 = Restaurant.create(@restaurant_params)
      restaurant2 = Restaurant.create(@restaurant_params)
      expect(restaurant1.update_attributes(slug: nil)).to eq false
      expect(restaurant2.update_attributes(slug: restaurant1.slug)).to eq false
    end

    it "is invalid with invalid phone number" do
      @restaurant_params[:phone] = 'abc'    
      expect(Restaurant.new(@restaurant_params)).not_to be_valid
    end

    it "is invalid with invalid email" do
      @restaurant_params[:email] = "abc"
      expect(Restaurant.new(@restaurant_params)).not_to be_valid
    end
  end
  
end