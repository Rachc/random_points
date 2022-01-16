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

  describe "get_users/1" do
    # As the test above, this test is fragile because depends of the
    # result of a random function. One way to fix this is creating a
    # module responsible for the random function, and passing it when we
    # are starting the server. That way, we can replace for a function
    # that returns a fixed umber when we are testing.
    test "Returns 2 user with points higher than max_number and update timestamp" do
      {:ok, user1} = Repo.insert(%User{points: 0})
      {:ok, user2} = Repo.insert(%User{points: 100})
      {:ok, user3} = Repo.insert(%User{points: 100})
      {:ok, _user4} = Repo.insert(%User{points: 100})

      interval_in_ms = 1000 * 60

      pid = start_supervised!({PointsServer, interval: interval_in_ms})

      %{users: users, timestamp: requested_timestamp} = PointsServer.get_users(pid)

      %{timestamp: new_timestamp} = PointsServer.get_state(pid)

      refute Enum.any?(users, fn user -> user.id == user1.id end)
      assert Enum.any?(users, fn user -> user.id == user2.id end)
      assert Enum.any?(users, fn user -> user.id == user3.id end)

      assert Enum.count(users) == 2

      refute requested_timestamp == new_timestamp
    end
  end
end
