defmodule RandomPointsWeb.PointView do
  use RandomPointsWeb, :view

  def render("index.json", %{data: %{users: users, timestamp: timestamp}}) do
    %{
      users: Enum.map(users, fn user -> %{id: user.id, points: user.points} end),
      timestamp: timestamp
    }
  end
end
