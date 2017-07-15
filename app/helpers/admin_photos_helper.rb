module AdminPhotosHelper

  def change_image_type(photo)
    content_tag 'span', "#{photo.img_type}", id: "admin_photo_#{photo.id}", 
                class: "label label-#{photo.image_type ? 'success' : 'info'}"

  end 

  def background_image
  	photo =  AdminPhoto.where(image_type: 0).last
  	if photo && photo.image.thumb("1024x2000#").present?
      photo.image.url host: "http://#{CURRENT_HOST}"
    else
      asset_path "layout_bg.png"
    end
  end
  def homepage_bg_photo
    @admin_photo =  AdminPhoto.where(image_type: 1).last
    if @admin_photo.present?
      @admin_photo.image.thumb("1024x500#").url(host: "http://#{CURRENT_HOST}").to_s
    else
      asset_path "homepage_default_bg_photo.jpg"
    end
  end

  def home_page_text
    home_photo =  AdminPhoto.where(image_type: 1).last
    title = home_photo.text_title
    content = home_photo.text_content
    hyperlink = home_photo.text_hyperlink || '#'
    text_photo = [title,content,hyperlink]
    text_photo
  end
end
