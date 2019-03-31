defmodule TimeTrackerWeb.TokenView do
  use TimeTrackerWeb, :view

  def render("index.json", %{token: token}) do
    %{token: token}
  end
end
