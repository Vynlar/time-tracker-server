use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :time_tracker, TimeTrackerWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :time_tracker, :simple_in_out, base_path: "http://localhost:8080"
