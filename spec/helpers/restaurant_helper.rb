def create_basic_schedules(restaurant)
  (1..7).each do |day_of_week|
    create(:schedule, { restaurant_id: restaurant.id })
  end
  restaurant.schedules
end

def create_basic_review(restaurant, user)
  create(:review, {user_id: user.id, restaurant_id: restaurant.id})
end

def request_new_photo_restaurant(restaurant, user, status = 0)
  # photo = ActionDispatch::Http::UploadedFile.new({
  #   :filename => 'test.jpg',
  #   :type => 'image/jpg',
  #   :tempfile => File.new("#{Rails.root}/test/fixtures/images/test.jpg")
  # })
  photo = fixture_file_upload("/images/test.jpg", 'image/jpg')
  create(:photo, {restaurant_id: restaurant.id, user_id: user.id, status: status, image: photo})
end


def create_filters restaurants=[]
  if restaurants.length > 0
    filter_ids = []
    filter_type_ids = []
    9.times do |i| 
      f_t = create(:"filter_type_#{i}")
      f = create(:filter, filter_type_id: f_t.id)
      filter_ids << f.id if i > 4
    end
    restaurants.each{ |restaurant|
      restaurant.filter_ids = filter_ids
      restaurant.filter_type_ids = filter_type_ids
      restaurant.save
    }
  end
end

def clear_database
  User.destroy_all
  Restaurant.destroy_all
end