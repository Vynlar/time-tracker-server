defmodule TimeTrackerWeb.SimpleInOutControllerTest do
  use TimeTrackerWeb.ConnCase
  doctest TimeTrackerWeb.SimpleInOutController

  test "POST /api/simpleinout/hook", %{conn: conn} do
    conn = post(conn, "/api/simpleinout/hook")

    assert json_response(conn, 200)
  end
end
