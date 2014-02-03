# overrides the method that ships with devise
# current version just changes the generated html a little
module DeviseHelper
  def devise_error_messages!
    return "" if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t("errors.messages.not_saved",
                      :count => resource.errors.count,
                      :resource => resource.class.model_name.human.downcase)

    html = <<-HTML
      <div id="error_explanation" class="alert alert-warning">
        <p class"lead">#{sentence}</p>
        <ul>#{messages}</ul>
      </div>
    HTML

    html.html_safe
  end
end
