defmodule TimeTrackerWeb.Router do
  use TimeTrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TimeTrackerWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", TimeTrackerWeb do
    pipe_through :api

    post "/simpleinout/hook", SimpleInOutController, :hook
    post "/simpleinout/oauth/token", SimpleInOutController, :token
    post "/simpleinout/statuses", SimpleInOutController, :statuses
  end
end
