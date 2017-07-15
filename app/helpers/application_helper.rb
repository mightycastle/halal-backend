#!/bin/env ruby
# encoding: utf-8

module ApplicationHelper
  def full_url(path='')
    if path.present?
      if path.include?('http://') || path.include?('https://') 
        path
      else 
        "http://#{CURRENT_HOST}#{path}"
      end
    else
      "#"
    end
  end

  def formated_url(path='')
    if path.present?
      if path.include?('http://') || path.include?('https://') 
        path
      else 
        "http://#{path}"
      end
    else
      "#"
    end
  end

  def link_to_add_fields(name, f, type)
    new_object = f.object.send "build_#{type}"
    id = "new_#{type}"
    fields = f.send("#{type}_fields", new_object, child_index: id) do |builder|
      render(type.to_s + "_fields", f: builder, is_new: true)
    end
    link_to '#', class: "btn btn-default fa fa-plus add_fields", data: {id: id, fields: fields.gsub("\n", "")} do
      content_tag :span, name, class: 'open-san'
    end
  end
  
  def filter_checked(filter_ids, id)
    if filter_ids
      filter_ids.include?(id)
    end
  end

  def bootstrap_class_for flash_type
    case flash_type
      when :success
        "alert-success"
      when :error
        "alert-error"
      when :alert
        "alert-block"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end
  
  def format_post_wordpress_content(post_id = nil)

    post = Wordpress.where(id: post_id).first
    result = ""
    if post
      post_meta = PostMetaWordpress.where(post_id: post_id, meta_key: '_thumbnail_id').first
      if post_meta
        meta_value = post_meta.meta_value
        target = PostMetaWordpress.where(post_id: meta_value, meta_key: '_wp_attached_file').first
        url = target.meta_value if target
        full_url = ['http://blog.halalgems.com/wp-content/uploads/',url].join('') if url
        attach_image = image_tag(full_url)
        if post.post_content && post.post_content.strip.present?
          post_content = post.post_content
          if post_content.include?('[caption')
            index1 = post_content.index('[caption')
            index2 = post_content.index('[/caption]')
            post_content.slice!(index1...(index2 + 10)) if (index1.present? && index2.present?)
          end
          if post_content.include?("<a href=''")
            index_start_a = caption.index('<a href=')
            index_end_a =  caption.index('/></a>')
            post_content.slice!(index_start_a...(index_end_a + 6)) if (index_start_a.present? && index_end_a.present?)
          
          elsif post_content.include?("<img")
            index_start_a = post_content.index('<img')
            index_end_a =  post_content.index('/>')
            post_content.slice!(index_start_a...(index_end_a + 2)) if (index_start_a.present? && index_end_a.present?)
          end
          post_content = remove_caption(strip_tags(post_content)).truncate(500)
          post_content.insert(0, attach_image ) if attach_image
          result = post_content
        end
      else
        if post.post_content && post.post_content.strip.present?
          post_content = post.post_content
          if post_content.include?('[caption')
            index1 = post_content.index('[caption')
            index2 = post_content.index('[/caption]')
            a_tag = ''
            caption = ''
            caption = post_content.slice!(index1...(index2 + 10))  if (index1.present? && index2.present?)
            if caption && caption.index('<a href=')
              index_start_a = caption.index('<a href=')
              index_end_a =  caption.index('/></a>')
              a_tag =  caption.slice!(index_start_a...(index_end_a + 6))  if (index_start_a.present? && index_end_a.present?)
            elsif caption && caption.index('<img')
              index_start_a = caption.index('<img')
              index_end_a =  caption.index('/>')
              a_tag = caption.slice!(index_start_a...(index_end_a + 2)) if (index_start_a.present? && index_end_a.present?)
            end
            post_content = remove_caption(strip_tags(post_content)).truncate(500)
            post_content.insert(0, a_tag) if a_tag
            result = post_content
          else
            result = remove_caption(strip_tags(post_content)).truncate(500)
          end
        end
      end
    end
    result
  end


  def remove_caption text
    while text.include?('[caption') do
      index1 = text.index('[caption')
      index2 = text.index('[/caption]')
      text.slice!(index1...(index2 + 10))  if (index1.present? && index2.present?)
    end
    text
  end
  
  def left_filter_checkbox(c,p, name_input = true)
    is_checked = filter_checked(p, "#{c.id},#{c.filter_type_id}")
    if name_input == true
      input = check_box_tag('filter_ids[]', "#{c.id},#{c.filter_type_id}", is_checked, id: "filter_#{c.id}", class: "filter-#{c.id}") 
    else
      input = check_box_tag('', "#{c.id},#{c.filter_type_id}", is_checked, id: "filter_#{c.id}", class: "filter-#{c.id}") 
    end
    label = "<label for='filter_#{c.id}' class='image-#{c.code}'>#{c.name}</label>"

    if c.code == "cuisine"
      "<div class='finder-checkbox-image col-lg-2 col-sm-3 col-xs-6'>#{input}#{label}</div>".html_safe
    else
      "<div class='finder-checkbox-image'>#{input}#{label}</div>".html_safe
    end
    
  end
  
  def restaurant_filter_checkbox(c,p)
    content_tag('label',check_box_tag('restaurant[filter_ids][]',  c.id, filter_checked(p, c.id),id: "restaurant_filter_ids_#{c.id}") + content_tag(:span, c.name), class: "checkbox")
  end
  
  def restaurant_filter_radio_button(c,p,ft)
    content_tag('label',radio_button_tag("#{ft}",  c.id, filter_checked(p, c.id)) + content_tag(:span, c.name), class: "radio")
  end
  
  def back_to_search
    link_to "Back to search", root_path
  end
  
  def back_to_search_result
    link_to "Back to search", session[:back_to_search_url] || root_path
  end
  
  def icon_ok_remove(is_ok)
    if is_ok
      "Yes"
    else
      "No"
    end    
  end
  
  def icon_price(price)
    if price.to_f < 15.0
      "£"
    elsif price.to_f > 45.0
      "£££"
    else
      "££"
    end
  end

  def notice_newsletter
    #content_tag(:div, content_tag(:div, "Great restaurant are on their way! In the meantime, search for a great meal on this page."), :class => "strong")
    "<div class='message_common alert-info'>
        <button class='close' data-dismiss='alert'>×</button>
        <div style='text-align:center'>
          <div><b>Great restaurants are on their way!</b></div>
          <div>In the meantime, search for a great meal on this page.</div>
        </div>
    </div>"
  end

  def random_image_other_page
    ap = AdminPhoto.where(:image_type =>false).offset(rand(AdminPhoto.where(:image_type =>false).count)).first
    if ap
      html = "#{image_tag("#{ap.image.thumb('1350x200#').url}",:class => 'image-cover-page')}
            <div class='hyperlinked_text container'>
                      <p class=' title_text_hypelink'> 
                          #{link_to ap.text_title.nil? ? '': 'ap.text_title', format_hyperlink(ap.text_hyperlink)} </p>
                      <p class='content_text_hypelink'>
                        #{ap.text_content }</p> </div>"
      html.html_safe                        
    else
      image_tag("/assets/banner/1.jpg")
    end
  end
  
  def collapse_css_class(filter_type_id)
    # case filter_type_id
    # when Restaurant::FILTER_TYPE_IDS[:cuisine],Restaurant::FILTER_TYPE_IDS[:price],Restaurant::FILTER_TYPE_IDS[:facilities]
    #   'expanse'
    # else
    #   'collapse'
    # end
  end
  
  def url_for_website(website)
    unless /^http:\/\// =~ website
      website = "http://#{website}"
    end
    website
  end
  
  def gem_rating(rate)
    html = ""
    (1..5).each do |i|
      html << gem_compare(i,rate) 
    end
    html.html_safe
  end
  
  def star_rating(rate)
    html = ""
    (1..5).each do |i|
      html << star_compare(i,rate) 
    end
    html.html_safe
  end
  
  def gem_compare(a,b)
    r = b - a
    case 
    when r >= 0
      '<span><i class="fa fa-star star"></i></span>'
    when r >= -0.5
      '<span><i class="fa fa-star-half-o star"></i></span>'
    else
      '<span><i class="fa fa-star-o star"></i></span>'
    end
  end
  
  def star_compare(a,b)
    r = b - a
    case 
    when r >= 0
      '<span><i class="fa fa-star star"></i></span>'
    when r >= -0.5
      '<span><i class="fa fa-star-half-o star"></i></span>'
    else
      '<span><i class="fa fa-star-o star"></i></span>'
    end
  end


  def avatar_url user = nil,size = nil
    if user && user.avatar
      user.avatar.thumb(size).url
    else
      asset_path "default_photo.png"
    end
  end
  
  def format_hyperlink link = ''
    unless link.nil? || link.strip.empty?
      if link.include?('http://') || link.include?('https://')
        link
      else
        link = "http://#{link}"
      end
    end
  end
      

  def format_DMY date = ''
    unless date == '' || date == nil
      date.strftime("%d-%m-%Y")
    end
  end
  
  def active_restaurants_pages?
    if ["restaurants", "search"].include?(params[:controller]) ||
      "#{params[:controller]}/#{params[:action]}" == "pages/home"
      true
    else
      false
    end
  end

end

module ActionView
  module Helpers
    module DateHelper
      def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false, options = {})
        from_time = from_time.to_time if from_time.respond_to?(:to_time)
        to_time = to_time.to_time if to_time.respond_to?(:to_time)
        distance_in_minutes = (((to_time - from_time).abs)/60).round
        distance_in_seconds = ((to_time - from_time).abs).round

        I18n.with_options :locale => options[:locale], :scope => :'datetime.distance_in_words' do |locale|
          case distance_in_minutes
            when 0..1
              return distance_in_minutes == 0 ?
                     locale.t(:less_than_x_minutes, :count => 1) :
                     locale.t(:x_minutes, :count => distance_in_minutes) unless include_seconds

              case distance_in_seconds
                when 0..4   then locale.t :less_than_x_seconds, :count => 5
                when 5..9   then locale.t :less_than_x_seconds, :count => 10
                when 10..19 then locale.t :less_than_x_seconds, :count => 20
                when 20..39 then locale.t :half_a_minute
                when 40..59 then locale.t :less_than_x_minutes, :count => 1
                else             locale.t :x_minutes,           :count => 1
              end

            when 2..44           then locale.t :x_minutes,      :count => distance_in_minutes
            when 45..89          then locale.t :about_x_hours,  :count => 1
            when 90..1439        then locale.t :about_x_hours,  :count => (distance_in_minutes.to_f / 60.0).round
            when 1440..2519      then locale.t :x_days,         :count => 1
            when 2520..10079     then locale.t :x_days,         :count => (distance_in_minutes.to_f / 1440.0).round
            when 10080..20159    then locale.t :about_x_weeks, :count => 1
            when 20160..43199   then locale.t :x_weeks,       :count => (distance_in_minutes.to_f / 10080.0).round
            when 43200..86399    then locale.t :about_x_months, :count => 1
            when 86400..525599   then locale.t :x_months,       :count => (distance_in_minutes.to_f / 43200.0).round
            else
              fyear = from_time.year
              fyear += 1 if from_time.month >= 3
              tyear = to_time.year
              tyear -= 1 if to_time.month < 3
              leap_years = (fyear > tyear) ? 0 : (fyear..tyear).count{|x| Date.leap?(x)}
              minute_offset_for_leap_year = leap_years * 1440
              # Discount the leap year days when calculating year distance.
              # e.g. if there are 20 leap year days between 2 dates having the same day
              # and month then the based on 365 days calculation
              # the distance in years will come out to over 80 years when in written
              # english it would read better as about 80 years.
              minutes_with_offset         = distance_in_minutes - minute_offset_for_leap_year
              remainder                   = (minutes_with_offset % 525600)
              distance_in_years           = (minutes_with_offset / 525600)
              if remainder < 131400
                locale.t(:about_x_years,  :count => distance_in_years)
              elsif remainder < 394200
                locale.t(:over_x_years,   :count => distance_in_years)
              else
                locale.t(:almost_x_years, :count => distance_in_years + 1)
              end
          end
        end
      end
    end
  end
end
