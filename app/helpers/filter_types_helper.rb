module FilterTypesHelper
  def filter_row(filter, index)
    html = ''
    css_class = "marker m#{index}"
    html << "<tr id='filter-#{filter.id}'>
      <td>#{content_tag(:div, '', class: css_class)}</td>
      <td>#{filter.filter_type.name }</td>
      <td>#{filter.name}</td>
      <td>
        <div class='btn-group btn-group-xs'>
          #{link_to (content_tag :span, ' Edit', class: 'open-san'), '#', fid: filter.id, fftid: filter.filter_type_id, fname: filter.name, findex: index+1,:class => "btn btn-default fa fa-edit btn-edit-filter", title: 'Edit'}
          #{link_to (content_tag :span, ' Delete', class: 'open-san'), "/admin/filters/#{filter.id}",:class => "btn btn-default fa fa-times-circle-o", id: filter.id, title: 'Delete', confirm: t('filter.delete_confirm') , :method => :delete }
        </div>
      </td>
      </tr>"
    html.html_safe
  end
end
