defmodule RandomPointsWeb.Controllers.PointControllerTest do
  use RandomPointsWeb.ConnCase

  describe "index/1" do
    test "returns users and a timestamp", %{conn: conn} do
      conn = get(conn, Routes.point_path(conn, :index))
      assert json_response(conn, 200) == %{"timestamp" => nil, "users" => []}
    end
  end
end
