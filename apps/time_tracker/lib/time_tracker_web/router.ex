defmodule TimeTrackerWeb.Router do
  use TimeTrackerWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :authenticated do
    plug(TimeTrackerWeb.Plugs.Auth)
  end

  scope "/", TimeTrackerWeb do
    pipe_through(:browser)

    get("/", PageController, :index)
  end

  scope "/api/simpleinout/oauth", TimeTrackerWeb do
    pipe_through(:api)

    post("/token", TokenController, :token)
  end

  scope "/api", TimeTrackerWeb do
    pipe_through(:authenticated)
    pipe_through(:api)

    #get("/simpleinout/statuses", SimpleInOutController, :statuses)
  end
end
