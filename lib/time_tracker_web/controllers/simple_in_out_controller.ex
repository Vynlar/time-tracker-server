defmodule TimeTrackerWeb.SimpleInOutController do
  use TimeTrackerWeb, :controller

  def hook(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{message: "ok"})
  end

  def token(conn, params) do
    # fetch keys from config
    config = Application.get_env(:time_tracker, __MODULE__)
    client_id = Keyword.get(config, :client_id)
    secret = Keyword.get(config, :client_id)

    # construct the URL
    url = make_url("/oauth/token")

    body =
      make_body(%{
        "grant_type" => "authorization_code",
        "client_id" => client_id,
        "client_secret" => secret,
        "code" => params["code"],
        "redirect_uri" => URI.encode("https://time.adrianaleixandre.com")
      })

    IO.inspect(body)

    response = HTTPoison.post(url, body)

    IO.inspect(response)

    access_token = Poison.decode!(response).access_token

    conn
    |> json(%{token: access_token})
  end

  @doc """
  Creates a url to simple in/out given a path and a list of query parameters

  ## Examples
      iex> TimeTrackerWeb.SimpleInOutController.make_url("/oauth/token")
      "https://www.simpleinout.com/oauth/token"
  """
  def make_url(path) do
    basePath = "https://www.simpleinout.com"
    basePath <> path
  end

  @doc """
  Encodes a query string of parameters to include in the request body

  ## Examples
      iex> TimeTrackerWeb.SimpleInOutController.make_url(%{"code" => "abc123", "user_id" => "gef456"})
      "code=abc123&user_id=gef456"
  """
  defp make_body(parameters) do
    basePath = "https://www.simpleinout.com"
    URI.encode_query(parameters)
  end
end
