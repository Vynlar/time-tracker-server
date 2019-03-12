defmodule TimeTrackerWeb.SimpleInOutControllerTest do
  use TimeTrackerWeb.ConnCase

  test "POST /api/simpleinout_hook", %{conn: conn} do
    conn = post(conn, "/api/simpleinout_hook")

    assert json_response(conn, 200)
  end
end
