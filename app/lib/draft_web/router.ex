defmodule DraftWeb.Router do
  use DraftWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DraftWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DraftWeb do
    pipe_through :browser

    live "/", DraftLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", DraftWeb do
  #   pipe_through :api
  # end
end
