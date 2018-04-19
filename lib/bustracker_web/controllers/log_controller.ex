defmodule BustrackerWeb.LogController do
  use BustrackerWeb, :controller

  alias Bustracker.History
  alias Bustracker.History.Log

  action_fallback BustrackerWeb.FallbackController

  def index(conn, _params) do
    logs = History.list_logs()
    render(conn, "index.json", logs: logs)
  end

  def create(conn, %{"log" => log_params}) do
    with {:ok, %Log{} = log} <- History.create_log(log_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", log_path(conn, :show, log))
      |> render("show.json", log: log)
    end
  end

  def show(conn, %{"id" => id}) do
    log = History.get_log!(id)
    render(conn, "show.json", log: log)
  end

  def update(conn, %{"id" => id, "log" => log_params}) do
    log = History.get_log!(id)

    with {:ok, %Log{} = log} <- History.update_log(log, log_params) do
      render(conn, "show.json", log: log)
    end
  end

  def delete(conn, %{"id" => id}) do
    log = History.get_log!(id)
    # with {:ok, %Log{}} <- History.delete_log(log) do
    #   send_resp(conn, :no_content, "")
    # end
    {:ok, _timeblocks} = History.delete_log(log)
    conn
    |> redirect(to: page_path(conn, :history))
  end

  def delete_all(conn, %{"id" => id}) do
    History.delete_history_by_user_id(id)
    conn
    |> redirect(to: page_path(conn, :history))
  end

end
