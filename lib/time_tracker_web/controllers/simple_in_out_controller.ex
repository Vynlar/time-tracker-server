defmodule TimeTrackerWeb.SimpleInOutController do
  use TimeTrackerWeb, :controller

  def hook(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{ message: "ok" })
  end
end
