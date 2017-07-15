module ReviewsHelper
  def get_rating_review(num)
    content_tag_for(:span, nil, :class => "rating_star_filled")
  end
  
  def status_label_class(status)
    label = "label-warning icon-warning-sign"
    if status == true
      label = "label-success"
    elsif status == false
      label = "label-important"
    end
    label
  end
  
  def status_label(status)
    status_text = t('review.new')
    if status == true
      status_text = t('review.public')
    elsif status == false
      status_text = t('review.rejected')
    end
    status_text
  end

  def list_review_sort_by_for_select_box
    Review::SORT_BY.map { |k,v| [k.to_s.humanize, v] }
  end
end
