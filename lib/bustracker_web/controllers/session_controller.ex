defmodule BustrackerWeb.SessionController do
  use BustrackerWeb, :controller

  alias Bustracker.Accounts
  alias Bustracker.Accounts.User

  def create(conn, %{"email" => email, "password" => password}) do
    user = Accounts.get_and_auth_user(email, password)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> redirect(to: page_path(conn, :bustracker))
    else
      conn
      |> put_flash(:error, "Invalid Email/Password")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
