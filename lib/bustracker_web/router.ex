defmodule BustrackerWeb.Router do
  use BustrackerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :get_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  def get_current_user(conn, _params) do
    user_id = get_session(conn, :user_id)
    user = Bustracker.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end

  scope "/", BustrackerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/bustracker", PageController, :bustracker
    get "/history", PageController, :history
    delete "/history/delete_all/:id", LogController, :delete_all
    resources "/users", UserController
    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", BustrackerWeb do
    pipe_through :api
    resources "/logs", LogController, except: [:new, :edit]
  end
end
