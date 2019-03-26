defmodule TimeTrackerWeb.SimpleInOutControllerTest do
  use TimeTrackerWeb.ConnCase
  doctest TimeTrackerWeb.SimpleInOutController

  test "POST /api/simpleinout/hook", %{conn: conn} do
    conn = post(conn, "/api/simpleinout/hook")

    assert json_response(conn, 200)
  end

  test "fetching token works given a code", %{conn: conn} do
    conn = post(conn, "/api/simpleinout/oauth/token", %{code: "a_valid_code"})

    body = json_response(conn, 200)
    assert %{"token" => "a_valid_token"} == body
  end

  test "fetching a token returns an error for an invalid code", %{conn: conn} do
    conn = post(conn, "/api/simpleinout/oauth/token", %{code: "an_invalid_code"})

    body = json_response(conn, 200)
    assert %{"error" => error} = body
  end
end