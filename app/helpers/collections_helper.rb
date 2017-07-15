module CollectionsHelper
  def disable_collection_button(collection = nil)
    conditions = collection.disabled || collection.disabled == nil if collection
    if conditions
      text = ' Enable'
      css_class = "btn-success fa fa-check-circle"
    else
      text = ' Disable'
      css_class = "btn-danger fa fa-ban"
    end
    link_to disable_toggle_collection_path(collection.id), class: "btn btn-mini #{css_class}", method: 'post', remote: true, confirm: t('collections.confirm_disable'), id: "btn_disable_#{collection.id}" do
      content_tag :span, text, class: 'open-san'
    end
  end
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

  def remove_collection_button(collection)
    link_to destroy_collection_collections_path(collection.id), class: "btn btn-default fa fa-minus-circle", method: 'post', confirm: t('collections.confirm_remove'), id: "btn_remove_#{collection.id}" do
      content_tag :span, 'Delete', class: 'open-san'
    end
  end

  def remove_collection_restaurant_button(collection, restaurant)
    link_to remove_restaurant_collection_path(id: collection.id, restaurant_id: restaurant.id), class: "btn btn-default fa fa-minus-circle", method: 'post', remote: true, confirm: t('collections.confirm_remove_restaurant'), id: "btn_remove_#{restaurant.id}" do
      content_tag :span, 'Delete', class: 'open-san'
    end
  end

end