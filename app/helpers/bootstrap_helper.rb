module BootstrapHelper
  def bootstrap_status_tag(tag_name, message, ok, ng = !ok)
    if ok
      content_tag tag_name, class: 'text-success' do
        content_tag :span, message, class: 'glyphicon glyphicon-ok'
      end
    elsif ng
      content_tag tag_name, class: 'text-danger' do
        content_tag :span, message, class: 'glyphicon glyphicon-remove'
      end
    else
      content_tag tag_name, message
    end
  end
end
