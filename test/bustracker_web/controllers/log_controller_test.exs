defmodule BustrackerWeb.LogControllerTest do
  use BustrackerWeb.ConnCase

  alias Bustracker.History
  alias Bustracker.History.Log

  @create_attrs %{directionId: "some directionId", predicted: ~N[2010-04-17 14:00:00.000000], route: "some route", schedule: ~N[2010-04-17 14:00:00.000000], stop: "some stop"}
  @update_attrs %{directionId: "some updated directionId", predicted: ~N[2011-05-18 15:01:01.000000], route: "some updated route", schedule: ~N[2011-05-18 15:01:01.000000], stop: "some updated stop"}
  @invalid_attrs %{directionId: nil, predicted: nil, route: nil, schedule: nil, stop: nil}

  def fixture(:log) do
    {:ok, log} = History.create_log(@create_attrs)
    log
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all logs", %{conn: conn} do
      conn = get conn, log_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create log" do
    test "renders log when data is valid", %{conn: conn} do
      conn = post conn, log_path(conn, :create), log: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, log_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "directionId" => "some directionId",
        "predicted" => ~N[2010-04-17 14:00:00.000000],
        "route" => "some route",
        "schedule" => ~N[2010-04-17 14:00:00.000000],
        "stop" => "some stop"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, log_path(conn, :create), log: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update log" do
    setup [:create_log]

    test "renders log when data is valid", %{conn: conn, log: %Log{id: id} = log} do
      conn = put conn, log_path(conn, :update, log), log: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, log_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "directionId" => "some updated directionId",
        "predicted" => ~N[2011-05-18 15:01:01.000000],
        "route" => "some updated route",
        "schedule" => ~N[2011-05-18 15:01:01.000000],
        "stop" => "some updated stop"}
    end

    test "renders errors when data is invalid", %{conn: conn, log: log} do
      conn = put conn, log_path(conn, :update, log), log: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete log" do
    setup [:create_log]

    test "deletes chosen log", %{conn: conn, log: log} do
      conn = delete conn, log_path(conn, :delete, log)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, log_path(conn, :show, log)
      end
    end
  end

  defp create_log(_) do
    log = fixture(:log)
    {:ok, log: log}
  end
end
