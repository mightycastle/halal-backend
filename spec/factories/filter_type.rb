FactoryGirl.define do
  factory :filter_type_1, :class => FilterType do  |f|
    f.name 'Cuisine'
    f.code 'cuisine'
    f.index_order 1
  end
  factory :filter_type_2, :class => FilterType do  |f|
    f.name 'Opening Hour'
    f.code 'open_hour'
    f.index_order 2
  end
  factory :filter_type_3, :class => FilterType do  |f|
    f.name 'Alcohol'
    f.code 'alcohol'
    f.index_order 3
  end
  factory :filter_type_4, :class => FilterType do  |f|
    f.name 'Shisha'
    f.code 'shisha'
    f.index_order 4
  end
  factory :filter_type_5, :class => FilterType do  |f|
    f.name 'Price'
    f.code 'price'
    f.index_order 5
  end
  factory :filter_type_6, :class => FilterType do  |f|
    f.name 'Facilities'
    f.code 'facility'
    f.index_order 6
  end
  factory :filter_type_7, :class => FilterType do  |f|
    f.name 'Halalgems status'
    f.code 'hal_status'
    f.index_order 7
  end  
  factory :filter_type_8, :class => FilterType do  |f|
    f.name 'Offers'
    f.code 'offer'
    f.index_order 8
  end  
  factory :filter_type_0, :class => FilterType do  |f|
    f.name 'Organic'
    f.code 'organic'
    f.index_order 9
  end  
end