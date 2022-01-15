defmodule RandomPoints.Repo do
  use Ecto.Repo,
    otp_app: :random_points,
    adapter: Ecto.Adapters.Postgres
end
