defmodule SIOMock.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  require Logger

  use Application

  @port 8080

  def start(_type, args) do
    plug_server = {Plug.Cowboy, scheme: :http, plug: SIOMock.Server, options: [port: @port]}
    # List all child processes to be supervised
    children =
      case args do
        [env: :test] -> [plug_server]
        [env: :dev] -> []
        _ -> []
      end

    Logger.info("Starting Simple In/Out mock server on port #{@port}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SIOMock.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
