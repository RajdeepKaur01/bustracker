defmodule Bustracker.HistoryTest do
  use Bustracker.DataCase

  alias Bustracker.History

  describe "logs" do
    alias Bustracker.History.Log

    @valid_attrs %{directionId: "some directionId", predicted: ~N[2010-04-17 14:00:00.000000], route: "some route", schedule: ~N[2010-04-17 14:00:00.000000], stop: "some stop"}
    @update_attrs %{directionId: "some updated directionId", predicted: ~N[2011-05-18 15:01:01.000000], route: "some updated route", schedule: ~N[2011-05-18 15:01:01.000000], stop: "some updated stop"}
    @invalid_attrs %{directionId: nil, predicted: nil, route: nil, schedule: nil, stop: nil}

    def log_fixture(attrs \\ %{}) do
      {:ok, log} =
        attrs
        |> Enum.into(@valid_attrs)
        |> History.create_log()

      log
    end

    test "list_logs/0 returns all logs" do
      log = log_fixture()
      assert History.list_logs() == [log]
    end

    test "get_log!/1 returns the log with given id" do
      log = log_fixture()
      assert History.get_log!(log.id) == log
    end

    test "create_log/1 with valid data creates a log" do
      assert {:ok, %Log{} = log} = History.create_log(@valid_attrs)
      assert log.directionId == "some directionId"
      assert log.predicted == ~N[2010-04-17 14:00:00.000000]
      assert log.route == "some route"
      assert log.schedule == ~N[2010-04-17 14:00:00.000000]
      assert log.stop == "some stop"
    end

    test "create_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = History.create_log(@invalid_attrs)
    end

    test "update_log/2 with valid data updates the log" do
      log = log_fixture()
      assert {:ok, log} = History.update_log(log, @update_attrs)
      assert %Log{} = log
      assert log.directionId == "some updated directionId"
      assert log.predicted == ~N[2011-05-18 15:01:01.000000]
      assert log.route == "some updated route"
      assert log.schedule == ~N[2011-05-18 15:01:01.000000]
      assert log.stop == "some updated stop"
    end

    test "update_log/2 with invalid data returns error changeset" do
      log = log_fixture()
      assert {:error, %Ecto.Changeset{}} = History.update_log(log, @invalid_attrs)
      assert log == History.get_log!(log.id)
    end

    test "delete_log/1 deletes the log" do
      log = log_fixture()
      assert {:ok, %Log{}} = History.delete_log(log)
      assert_raise Ecto.NoResultsError, fn -> History.get_log!(log.id) end
    end

    test "change_log/1 returns a log changeset" do
      log = log_fixture()
      assert %Ecto.Changeset{} = History.change_log(log)
    end
  end
end
