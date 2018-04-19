defmodule BustrackerWeb.PageController do
  use BustrackerWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
  def bustracker(conn, _params) do
    render conn, "bustracker.html"
  end
  def history(conn, _params) do
    render conn, "history.html"
  end
end
