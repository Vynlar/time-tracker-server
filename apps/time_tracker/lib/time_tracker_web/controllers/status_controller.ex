defmodule TimeTrackerWeb.StatusController do
  use TimeTrackerWeb, :controller

  def index(conn, _params) do
    token = hd(get_req_header(conn, "authorization"))

    statuses = SimpleInOut.Statuses.today(token)

    json(conn, %{statuses: statuses})
  end
end
