defmodule BustrackerWeb.LogView do
  use BustrackerWeb, :view
  alias BustrackerWeb.LogView

  def render("index.json", %{logs: logs}) do
    %{data: render_many(logs, LogView, "log.json")}
  end

  def render("show.json", %{log: log}) do
    %{data: render_one(log, LogView, "log.json")}
  end

  def render("log.json", %{log: log}) do
    %{id: log.id,
      stop: log.stop,
      route: log.route,
      directionId: log.directionId,
      schedule: log.schedule,
      predicted: log.predicted,
      user_id: log.user_id}
  end
end
