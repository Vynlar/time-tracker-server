defmodule TimeTrackerWeb.TokenController do
  use TimeTrackerWeb, :controller

  @doc """
  Handles success case of token fetch.
  """
  def token(conn, %{"code" => code}) do
    token = SimpleInOut.fetch_token(code)
    render(conn, "index.json", token: token)
  end

  @doc """
  Handles the invalid request case (code missing) of token fetch.
  The code is a string that is passed from simple in/out to the UI,
  and then passed to this endpoint to fetch a token.
  """
  def token(_conn, _params) do
    raise TimeTrackerWeb.JsonError,
      message: "request is missing code parameter",
      code: "token/code-required"
  end
end
