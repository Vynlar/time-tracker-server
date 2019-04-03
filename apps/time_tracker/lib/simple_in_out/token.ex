defmodule SimpleInOut.Token do
  @base_path Keyword.get(Application.get_env(:time_tracker, :simple_in_out), :base_path)

  def fetch(code) do
    %{secret: secret, client_id: client_id} = get_keys()

    url = @base_path <> "/oauth/token"

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
      {:ok, %{body: body, status_code: 200}} ->
        case Poison.decode(body) do
          {:ok, %{"access_token" => token}} ->
            token

          {:error, _, _} ->
            raise SimpleInOut.Error.ParseError
        end
      {:ok, %{status_code: status_code, body: body}} ->
        raise SimpleInOut.Error.UpstreamError, "Status: #{status_code}, body: #{body}"

      {:error, err} ->
        raise SimpleInOut.Error.ConnectionError
    end
  end

  defp get_keys do
    config = Application.get_env(:time_tracker, :simple_in_out)
    client_id = Keyword.get(config, :client_id)
    secret = Keyword.get(config, :secret)

    %{secret: secret, client_id: client_id}
  end
end
