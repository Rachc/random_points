defmodule RandomPointsWeb.PointController do
  use RandomPointsWeb, :controller

  alias RandomPoints.Users.PointsServer

  def index(conn, _params) do
    PointsServer.get_users()
    |> handle_response(conn, "index.json")
  end

  defp handle_response(points, conn, view) do
    conn
    |> put_status(:ok)
    |> render(view, data: points)
  end
end
