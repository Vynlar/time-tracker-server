defmodule TimeTrackerWeb.ErrorView do
  use TimeTrackerWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  def render(_template, %{reason: error}) do
    if Map.has_key?(error, :message) and Map.has_key?(error, :code) do
      %{error: error.message, code: error.code}
    end
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
