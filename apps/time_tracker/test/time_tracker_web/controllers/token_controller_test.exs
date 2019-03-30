defmodule TimeTrackerWeb.TokenControllerTest do
  use TimeTrackerWeb.ConnCase
  doctest TimeTrackerWeb.TokenController

  describe "token endpoint" do
    test "fetching token works given a code", %{conn: conn} do
      conn = post(conn, "/api/simpleinout/oauth/token", %{code: "a_valid_code"})

      body = json_response(conn, 200)
      assert %{"token" => "a_valid_token"} == body
    end

    test "fetching a token returns an error for an invalid code", %{conn: conn} do
      conn = post(conn, "/api/simpleinout/oauth/token", %{code: "an_invalid_code"})

      body = json_response(conn, 404)
      assert %{"error" => error} = body
    end
  end
end
