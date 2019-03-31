defmodule TimeTrackerWeb.JsonError do
  defexception [:message, :code]

  def exception(values, message: message, code: code) do
    %TimeTrackerWeb.JsonError{message: message, code: code}
  end
end
