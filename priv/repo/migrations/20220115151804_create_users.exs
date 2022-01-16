defmodule RandomPoints.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :points, :integer, default: 0

      timestamps()
    end

    create constraint("users", :points_must_be_between_0_and_100,
             check: "points >= 0 and points <= 100"
           )
  end
end
