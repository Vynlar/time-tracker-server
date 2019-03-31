defmodule SimpleInOut.Client do
  @base_path Keyword.get(Application.get_env(:time_tracker, :simple_in_out), :base_path)

  def fetch_token(code) do
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
         code: code,
         redirect_uri: "https://time.adrianaleixandre.com"
       ]}

    response = HTTPoison.post(url, body)

    case response do
      {:ok, %{body: body}} ->
        case Poison.decode(body) do
          {:ok, %{"access_token" => token}} ->
            token

          {:ok, %{"error_description" => error}} ->
            raise TimeTrackerWeb.JsonError,
              message: "Received error from Simple In/Out: " <> error,
              code: "simple-in-out/upstream-error"

          {:error, error} ->
            raise TimeTrackerWeb.JsonError,
              message: "Error parsing Simple In/Out response",
              code: "simple-in-out/parse-error"
        end

      {:err, err} ->
        raise TimeTrackerWeb.JsonError,
          message: "Error contacting Simple In/Out",
          code: "simple-in-out/connection-error"
    end
  end

  @doc """
  Creates a url to simple in/out given a path and a list of query parameters

  ## Examples
      iex> SimpleInOut.Client.make_url("/oauth/token")
      "http://localhost:8080/oauth/token"
  """
  def make_url(path) do
    @base_path <> path
  end
end
