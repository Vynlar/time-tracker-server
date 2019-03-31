defmodule TimeTrackerWeb.TokenControllerTest do
  use TimeTrackerWeb.ConnCase
  doctest TimeTrackerWeb.TokenController

  @path "/api/simpleinout/oauth/token"

  describe "token endpoint" do
    test "fetching token works given a code", %{conn: conn} do
      conn = post(conn, @path, %{code: "a_valid_code"})

      body = json_response(conn, 200)
      assert %{"token" => "a_valid_token"} == body
    end

    test "fetching a token returns an error for an invalid code", %{conn: conn} do
      error = catch_error(post(conn, @path, %{code: "an_invalid_code"}))
      assert error.code == "simple-in-out/upstream-error"
      assert error.message == "Received error from Simple In/Out: Invalid code"
    end

    test "returns error for missing code", %{conn: conn} do
      error = catch_error(post(conn, @path, %{}))
      assert error.code == "simple-in-out/code-required"
      assert error.message == "request is missing code parameter"
    end
  end
end
