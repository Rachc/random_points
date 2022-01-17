# 🚀 RandomPoints
Random points has a genserver that defines a max number and draws 2 users that have more points than the max points.
Max number and user points are updated every minute.

## Technologies
* **Elixir:** 1.12.2
* **Erlang:** 24.0.5
* **Postgres:** 12.9

## How to start on your machine
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create, migrate and seed your database with a million users using `mix ecto.setup` command.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser or API Platform.

## Endpoints - Or how to use the API
### Get two users with more points than the max number
This endpoint also brings the date and time from the last time this endpoint was fetched.
* Request: GET `/`
* Response example:
```
{
    "timestamp": "2022-01-17T14:10:27.794435Z",
    "users": [
        {
            "id": 579516,
            "points": 33
        },
        {
            "id": 579519,
            "points": 80
        }
    ]
}
```
## Some considerations about this application:
My thought process and some of the decisions are explained in the commits
### Things that could improve:
* I'm testing only the happy path. It's missing the scenarios that they may break.
* Having the same genserver to update AND read the user is fine by now, but if we need to scale this application, this will be a bottleneck.