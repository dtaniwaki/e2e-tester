module FormHelper
  def form_errors_for(object)
    render('shared/form_errors', object: object) if object.present? && object.errors.present?
  end
end
