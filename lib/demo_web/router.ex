defmodule DemoWeb.Router do
  use DemoWeb, :router

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

  scope "/", DemoWeb do
    pipe_through [:browser]

    get "/", PageController, :index

    scope "/posts" do
      resources "/", PostController
    end

    scope "/auth" do
      get "/signout",            AuthController, :signout
      get "/:provider",          AuthController, :request
      get "/:provider/callback", AuthController, :callback
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", DemoWeb do
  #   pipe_through :api
  # end
end
