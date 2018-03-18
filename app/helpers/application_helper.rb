module ApplicationHelper
  def input_status_class(model, field)
    model.errors.messages[field].any? ? "is-invalid" : ""
  end

  def invalid_msg(model, field)
    content_tag :div, model.errors.messages[field][0], class: "invalid-feedback d-block"
  end

  def is_invalid?(model, field)
    model.errors.messages[field].any?
  end
end
