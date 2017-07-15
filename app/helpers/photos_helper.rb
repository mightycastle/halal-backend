module PhotosHelper
  def get_image_url(photo)
    if photo && photo.image.present?
      photo.image.thumb("260x210#").url
       # asset_path "no_restaurant.png"
    else
      asset_path "restaurant_default.png"
    end

  end

  def get_image_cover_url(cover = nil)
    if cover && cover.image.present?
      cover.image.url
       # asset_path "no_restaurant.png"
    else
      asset_path "restaurant_default.png"
    end

  end
  
  def photo_status_formated(status)
    result = ''
    text = Photo::STATUS[status]
    if status == 0 
      result = content_tag :span, text, class: 'label label-warning'
    elsif status == 1
      result = content_tag :span, text, class: 'label label-success'
    else
      result = content_tag :span, text, class: 'label label-danger'
    end
    return result.html_safe
  end


end
