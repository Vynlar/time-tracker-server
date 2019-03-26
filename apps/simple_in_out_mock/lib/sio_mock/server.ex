defmodule SIOMock.Server do
  use Plug.Router

  plug Plug.Parsers, parsers: [:urlencoded],
                     pass: ["text/*"],
                     json_decoder: Poison

  plug Plug.Logger

  plug :match
  plug :dispatch

  post "/oauth/token" do
    case conn.params do
      %{
        "grant_type" => "authorization_code",
        "client_id" => client_id,
        "client_secret" => client_secret,
        "code" => code,
        "redirect_uri" => "https://time.adrianaleixandre.com",
      } ->
        if code == "a_valid_code" do
          json(conn, %{access_token: "a_valid_token"})
        else
          send_resp(conn, 404, "Invalid token")
        end
      _ ->
        send_resp(conn, 400, "Invalid request format")
    end
  end

  match _ do
    send_resp(conn, 404, "Invalid route")
  end

  defp json(conn, data, code\\200) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Poison.encode!(data))
  end
end