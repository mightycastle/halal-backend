module MenusHelper

  def menu_row(menu)
    html = "<tr id='menu-#{menu.id}'>
          <td></td>
          <td>#{menu.file_name}</td>
          <td>
            #{ link_to '', menu.menu.url, class: 'fa fa-cloud-download fa-lg ', target: "_blank", title: 'Download' if menu.menu}
            #{ link_to '', menu_path(menu), method: 'delete', remote: true, class: 'fa fa-trash-o fa-2xlg', title: 'Delete', confirm: 'Do you really want to delete this?'}
          </td>
        </tr>"
    html.html_safe
  end

  def menu_row_user(menu)
    html = "<tr id='menu-#{menu.id}'>
          <td></td>
          <td class='menu-name'>#{menu.file_name}</td>
          <td class='menu-action'>
            #{ link_to '', menu.menu.url, class: 'fa fa-eye fa-lg ', target: "_blank", title: 'View' if menu.menu}
            #{ link_to '', menu.menu.url, class: 'fa fa-cloud-download fa-lg ',download:true, title: 'Download' if menu.menu}
          </td>
        </tr>"
    html.html_safe
  end

end
