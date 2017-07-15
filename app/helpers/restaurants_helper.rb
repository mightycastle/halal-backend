module RestaurantsHelper
  def text_disabled(is_disable)
    case is_disable
    when true
      content_tag(:span, " Disabled", class: "label label-important")
    when false
      content_tag(:span, " Enabled", class: "label label-success")
    else
      content_tag(:span, " New", class: "label label-warning")
    end
  end
  def btn_disabled(is_disable)
    if is_disable 
      "btn-success fa fa-check-circle"
    else
      "btn-danger fa fa-ban"
    end
  end
  def title_disable_text(is_disable)
    if is_disable 
      "Enable"
    else
      "Disable"
    end
  end
  def backend_thumb_url(restaurant = nil)
    if restaurant.present? && restaurant.cover.present?
      restaurant.cover.image.thumb("80x80#").url
    else
      asset_path "no_restaurant.png"
    end
  end

  def cover_thumb_url(restaurant = nil)
    if restaurant.present? && restaurant.cover.present? && restaurant.cover.image.present?
      restaurant.cover.image.thumb("300x300#").url
    else
      asset_path "no_restaurant.png"
    end
  end

  def my_review_thumb_url(restaurant = nil)
    if restaurant.present? && restaurant.cover.present?
      restaurant.cover.image.thumb("300x300#").url
    else
      asset_path "no_restaurant.png"
    end
  end

  def search_thumb_url(restaurant = nil)
    if restaurant.present? && restaurant.cover.present?
      restaurant.cover.image.thumb("150x118#").url
    else
      asset_path "no_restaurant_search.png"
    end
  end
  
  def disable_restaurant_button(restaurant = nil)
    conditions = restaurant.disabled || restaurant.disabled == nil if restaurant
    if conditions
      text = ' Enable'
      css_class = "btn-success fa fa-check-circle"
    else
      text = ' Disable'
      css_class = "btn-danger fa fa-ban"
    end
    link_to disable_toggle_restaurant_path(restaurant.slug), class: "btn btn-mini #{css_class}", method: 'post', remote: true, confirm: t('restaurant.confirm_disable'), id: "btn_disable_#{restaurant.id}" do
      content_tag :span, text, class: 'open-san'
    end
  end
  
  def check_halagem_status(restaurant_id, filter_id)
    if restaurant_id.present? && filter_id.present?
      @restaurant =  Restaurant.find_by_id(restaurant_id) 
      @filter = @restaurant.filters.where(id: filter_id)
      if @filter.length != 0
        check_box_tag 'filter_id[]', filter_id, true
      else
        check_box_tag 'filter_id[]', filter_id
      end
    end
  end


  def alcohol_filter restaurant = nil
    if restaurant.present? && restaurant.is_byob?
      image_tag("restaurant_finder/byo_icon_hover.png", alt:"BYO", class: 'jtooltip icon-small', title:"BYO")

    elsif restaurant.is_no_alcohol?
      image_tag("restaurant_finder/no_alcohol_icon_hover.png", alt:"Alcohol", class:"jtooltip icon-small", title:"No Alcohol")
    elsif restaurant.is_alcohol?
      image_tag("restaurant_finder/alcohol_icon_hover.png", alt:"Alcohol", class:"jtooltip icon-small", title:"Alcohol")
    end
  end

  def is_owner_restaurant?(user, restaurant)  
    user.present? && restaurant.present? && restaurant.try(:user_id) == user.try(:id)
  end
end
