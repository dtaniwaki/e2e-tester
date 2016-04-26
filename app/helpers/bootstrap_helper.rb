module BootstrapHelper
  def bootstrap_status_tag(tag_name, message, ok, ng = !ok)
    if ok
      content_tag tag_name, class: 'text-success' do
        content_tag(:span, '', class: 'glyphicon glyphicon-ok') + message
      end
    elsif ng
      content_tag tag_name, class: 'text-danger' do
        content_tag(:span, '', class: 'glyphicon glyphicon-remove') + message
      end
    else
      content_tag tag_name, message
    end
  end
end
