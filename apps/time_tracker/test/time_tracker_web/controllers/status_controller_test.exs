defmodule TimeTrackerWeb.StatusControllerTest do
  use TimeTrackerWeb.ConnCase

  @path "api/simpleinout/statuses"

  describe "get status endpoint" do
    test "fetching statuses works", %{conn: conn} do
      conn =
        conn
        |> put_req_header("authorization", "Bearer a_valid_token")
        |> get(@path)

      body = json_response(conn, 200)
      statuses = body["statuses"]

      assert body

      assert [
               %{"status" => "in", "time" => 1234, "message" => "IN"},
               %{"status" => "out", "time" => 4567, "message" => "OUT"},
             ] = statuses
    end
  end
end
