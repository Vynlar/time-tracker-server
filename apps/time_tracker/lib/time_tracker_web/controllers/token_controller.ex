defmodule TimeTrackerWeb.TokenController do
  use TimeTrackerWeb, :controller

  @base_path Keyword.get(Application.get_env(:time_tracker, :simple_in_out), :base_path)

  def statuses(conn, _params) do
    auth_header = get_req_header(conn, "Authorization")

    conn
    |> put_status(:bad_request)
    |> json(%{
      "error" =>
        "SimpleInOut token required. Fetch one using the simpleinout/oauth/token endpont."
    })
  end

  def token(conn, params) do
    # fetch api keys from config
    config = Application.get_env(:time_tracker, :simple_in_out)
    client_id = Keyword.get(config, :client_id)
    secret = Keyword.get(config, :secret)

    url = make_url("/oauth/token")

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

  defp handle_token_response(conn, {:ok, response}) do
    case Poison.decode(response.body) do
      {:ok, body} ->
        access_token = Map.get(body, "access_token")
        server_error = Map.get(body, "error")

        if access_token != nil do
          conn
          |> render("index.json", token: access_token)
        else
          send_error(conn, server_error)
        end

      _ ->
        send_error(conn, "Error parsing response from Simple in/out")
    end
  end

  defp handle_token_response(conn, {:err, error}) do
    send_error(conn, error)
  end

  defp send_error(conn, error) do
    conn
    |> put_status(:not_found)
    |> json(%{error: error})
  end

  @doc """
  Creates a url to simple in/out given a path and a list of query parameters

  ## Examples
      iex> TimeTrackerWeb.TokenController.make_url("/oauth/token")
      "http://localhost:8080/oauth/token"
  """
  def make_url(path) do
    @base_path <> path
  end
end
