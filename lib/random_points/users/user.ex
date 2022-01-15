defmodule RandomPoints.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :points, :integer

    timestamps([type: :utc_datetime_usec])
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:points])
    |> validate_inclusion(:points, 0..100)
  end
end
