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
    secret = Keyword.get(config, :secret)

    # construct the URL
    url = make_url("/oauth/token")

    # body =
    #   make_body(%{
    #     "grant_type" => "authorization_code",
    #     "client_id" => client_id,
    #     "client_secret" => secret,
    #     "code" => params["code"],
    #     "redirect_uri" => URI.encode("https://time.adrianaleixandre.com")
    #   })
    body =
      {:form,
       [
         grant_type: "authorization_code",
         client_id: client_id,
         client_secret: secret,
         code: params["code"],
         redirect_uri: "https://time.adrianaleixandre.com"
       ]}

    response = HTTPoison.post(url, body)
    handle_token_response(conn, response)
  end

  @doc """
  Handle the success case:
  1. Decode the body using json
  2. Get out the access token
  """
  defp handle_token_response(conn, {:ok, response}) do
    body = Poison.decode!(response.body)
    access_token = Map.get(body, "access_token")
    server_error = Map.get(body, "error")

    if access_token != nil do
      conn
      |> json(%{token: access_token})
    else
      send_error(conn, server_error)
    end
  end

  @doc """
  Handle the error code for when the actual token request fails
  """
  defp handle_token_response(conn, {:err, error}) do
    send_error(conn, error)
  end

  defp send_error(conn, error) do
    conn
    |> json(%{error: error})
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
