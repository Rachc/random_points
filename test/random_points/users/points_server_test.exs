defmodule PointsServerTest do
  use RandomPoints.DataCase, async: false

  alias RandomPoints.Users.PointsServer
  alias RandomPoints.Repo
  alias RandomPoints.Users.User

  describe "start_link/1" do
    test "guarantee the server starts" do
      interval_in_ms = 1000 * 60
      assert {:ok, _pid} = PointsServer.start_link(interval: interval_in_ms)
    end
  end

  describe "get_state/1" do
    test "initiates the genserver with max_point between 0 and 100, and a nil timestamp" do
      interval_in_ms = 1000 * 60

      pid = start_supervised!({PointsServer, interval: interval_in_ms})

      %{max_number: max_number, timestamp: timestamp} = PointsServer.get_state(pid)

      assert max_number <= 100
      assert max_number >= 0
      assert timestamp == nil
    end
  end

  describe "update_points/2" do
    test "Updates max points, and user points" do
      {:ok, user} = Repo.insert(%User{})
      interval_in_ms = 5

      pid = start_supervised!({PointsServer, interval: interval_in_ms})

      %{max_number: first_max_number} = PointsServer.get_state(pid)
      %User{points: first_user_points} = Repo.reload(user)

      assert first_user_points == 0

      Process.sleep(interval_in_ms * 2)

      %{max_number: second_max_number} = PointsServer.get_state(pid)
      %User{points: second_user_points} = Repo.reload(user)

      refute first_max_number == second_max_number
      refute first_user_points == second_user_points
    end
  end
end
