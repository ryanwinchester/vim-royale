defmodule ScrollerWeb.Router do
  use ScrollerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {ScrollerWeb.Layouts, :root}
    plug :protect_from_forgery
    # plug :put_secure_browser_headers
  end

  scope "/", ScrollerWeb do
    pipe_through :browser
    live "/", ClientLive.Index, :terminal
  end
end
