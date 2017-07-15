module UsersHelper
  def user_status status
    case status
    when User::STATUS[0]
      css_class = 'label-default'
    when User::STATUS[1]
      css_class = 'label-success'      
    when User::STATUS[2]
      css_class = 'label-important'
    end
    content_tag 'span', status.capitalize, class: "label #{css_class}" if status
  end 
  
  def status_css status
    case status
    when User::STATUS[0]
      css_class = 'icon-warning-sign'
    when User::STATUS[1]
      css_class = 'btn-success icon-ok'      
    when User::STATUS[2]
      css_class = 'btn-danger icon-ban-circle'
    end
    css_class
  end 
  
  def disable_user_button user
    list_link = '<div class="btn-group btn-group-xs">'
    status_list = User::STATUS
    case user.status
    when status_list[0]
      list_link << link_to((content_tag :span, ' Disable', class: 'open-san'), change_status_user_path(user.id,status_list[2]), 
                           method: 'post', remote: true, class: "btn btn-danger fa fa-ban #{status_css status_list[2]}", title: 'Disable')
    when status_list[1]
      list_link << link_to((content_tag :span, ' Disable', class: 'open-san'), change_status_user_path(user.id,status_list[2]), 
                           method: 'post', remote: true, class: "btn btn-danger fa fa-ban #{status_css status_list[2]}", title: 'Disable')
    when User::STATUS[2]
      list_link << link_to((content_tag :span, ' Enable', class: 'open-san'), change_status_user_path(user.id,status_list[0]), 
                           method: 'post', remote: true, class: "btn btn-success fa fa-check-circle #{status_css status_list[0]}", title: 'Enable')
    end
    list_link << '</div>'
    list_link.html_safe
  end
  
  def user_status_color status
    case status
    when "unverified"
      "label-danger"
    when "verified"
      "label-success"
    when "suspended"
      "label-important"
    else 
      "label-inverse"
    end
  end
  
  def user_status_color_btn status
    case status
    when "unverified"
      "label-danger"
    when "verified"
      "btn-success"
    when "suspended"
      "btn-warning"
    else 
      "btn-inverse"
    end
  end
  
  def backend_avatar_url(user)
    if user.avatar
      user.avatar.thumb("100x100#").url 
    else
      asset_path "no_avatar.png" 
    end
  end

  def toggle_gem_hunter_button field_status, user_id
    html = '<div class="btn-group btn-group-xs">'
    modal_html = '<div>'
    case field_status
    when true
      html << link_to((content_tag :span, ' Remove Gem Hunter', class: 'open-san'), toggle_gem_hunter_user_path(user_id, 0), 
                           method: 'post', remote: true, class: "btn btn-success fa fa-check-circle", title: 'Enable', 'data-confirm' => I18n.t('layout.are_you_sure'))
    else
      modal_html << toggle_gem_hunter_modal(user_id)
      html = modal_html
    end
    html << '</div>'

    html.html_safe
  end  

  def toggle_gem_hunter_modal user_id
    html = '<div class="btn-group btn-group-xs">'
    html << link_to(
      (content_tag :span, ' Set Gem Hunter', class: 'open-san'), "#", 
      class: "btn btn-danger fa fa-check-circle", title: 'Disable',
      :"data-toggle" => "modal", :"data-target" => "#user_change_gem_hunter_#{user_id} #set-gem-hunter-modal"
    )
    html << '</div>'
    html << <<-HTML
      <!-- Modal -->
      <div class="modal fade" id="set-gem-hunter-modal" tabindex="-1" role="dialog" aria-labelledby="set-gem-hunter-modal-label" aria-hidden="true">
        <div class="modal-dialog">
          <div class="modal-content">
            <div class="modal-header">
              <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
              <h4 class="modal-title" id="set-gem-hunter-modal-label">Set Gem Hunter</h4>
            </div>
            <div class="modal-body">
    HTML
    html << toggle_gem_hunter_modal_form(user_id)
    html << <<-HTML
            </div>
            <!-- <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              <button type="button" class="btn btn-primary">Save changes</button>
            </div> -->
          </div>
        </div>
      </div>
    HTML
    html.html_safe
  end

  def toggle_gem_hunter_modal_form user_id
    form_content = <<-HTML
      <div class="form-group">
        <label for="gem_hunter_wordpress_url" class="col-sm-2 control-label">Profile url</label>
        <div class="col-sm-10">
          <input type="text" class="form-control" id="gem_hunter_wordpress_url" name="gem_hunter_wordpress_url" placeholder="Profile url", required>
        </div>
      </div>
      <div class="form-group">
        <div class="col-sm-offset-2 col-sm-10">
          <input type="hidden" id="status" name="status" value="1">
          <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          <button type="submit" class="btn btn-success">Submit</button>
        </div>
      </div>
    HTML
    form_tag(toggle_gem_hunter_user_path(user_id, 1), method: :post, remote: true, class: "toggle-gem-hunter-form form-horizontal", role: "form") do
      form_content.html_safe
    end
  end
end
