defmodule SIOMock.Server do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded],
    pass: ["text/*"],
    json_decoder: Poison
  )

  plug(Plug.Logger)

  plug(:match)
  plug(:dispatch)

  post "/oauth/token" do
    case conn.params do
      %{
        "grant_type" => "authorization_code",
        "client_id" => client_id,
        "client_secret" => client_secret,
        "code" => code,
        "redirect_uri" => "https://time.adrianaleixandre.com"
      } ->
        if client_id == "" || client_secret == "" do
          # malformed request case
          json(conn, 400, %{"error" => "Invalid request format"})
        end

        case code do
          "a_valid_code" ->
            json(conn, %{access_token: "a_valid_token"})

          "an_invalid_code" ->
            json(conn, 404, %{
              "error" => "invalid_request",
              "error_description" => "Invalid code"
            })

          "force_bad_response" ->
            conn
            |> put_resp_content_type("application/json")
            |> send_resp(500, "this is not valid json")
           "force_no_response" -> conn
        end

      _ ->
        # malformed request case
        json(conn, 400, %{"error" => "Invalid request format"})
    end
  end

  match _ do
    send_resp(conn, 404, "Invalid route")
  end

  defp json(conn, code \\ 200, data) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(code, Poison.encode!(data))
  end
end
