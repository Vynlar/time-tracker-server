defmodule TimeTrackerWeb.Plugs.Auth do
  import Plug.Conn

  defmodule UnauthrorizedRequestError do
    @moduledoc """
    Error raised if a request does not have the Authorization header present
    """
    defexception message: ""
  end

  def init(opts), do: opts

  def call(conn, _opts) do
    auth_header = get_req_header(conn, "authorization")

    if auth_header == [] || auth_header == "" do
      raise(UnauthrorizedRequestError)
    end

    conn
  end
end
