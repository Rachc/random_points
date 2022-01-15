alias RandomPoints.Repo
alias RandomPoints.Users.User

timestamp = DateTime.utc_now()

1..1_000_000
|> Enum.map(fn _x -> %{points: 0, inserted_at: timestamp, updated_at: timestamp} end)
|> Enum.chunk_every(10_000)
|> Enum.each(fn entries ->
  Repo.insert_all(User, entries)
end)
