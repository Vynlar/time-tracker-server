defmodule TimeTrackerWeb.TokenController do
  use TimeTrackerWeb, :controller
  require IEx

  def statuses(conn, _params) do
    auth_header = get_req_header(conn, "Authorization")

    conn
    |> put_status(:bad_request)
    |> json(%{
      "error" =>
        "SimpleInOut token required. Fetch one using the simpleinout/oauth/token endpont."
    })
  end

  def token(conn, %{"code" => code}) do
    token = SimpleInOut.Client.fetch_token(code)
    render(conn, "index.json", token: token)
  end

  def token(_conn, _params) do
    raise TimeTrackerWeb.JsonError,
      message: "request is missing code parameter",
      code: "simple-in-out/code-required"
  end
end
