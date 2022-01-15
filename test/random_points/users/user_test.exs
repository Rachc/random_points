defmodule UserTest do
  use ExUnit.Case
  alias RandomPoints.Users.User


  describe "changeset" do
    test "Returns invalid if user's point is lesser than 0 and higher than 100" do
      valid_point = Enum.random(0..100)
      invalid_point = Enum.random([-1, 101])

      valid_changeset = User.changeset(%User{}, %{points: valid_point})
      invalid_changeset = User.changeset(%User{}, %{points: invalid_point})

      assert valid_changeset.valid?
      refute invalid_changeset.valid?
    end
  end
end
