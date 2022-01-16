defmodule RandomPoints.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      RandomPoints.Repo,
      # Start the Telemetry supervisor
      RandomPointsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RandomPoints.PubSub},
      # Start the Endpoint (http/https)
      RandomPointsWeb.Endpoint,
      # Start a worker by calling: RandomPoints.Worker.start_link(arg)
      # {RandomPoints.Worker, arg}
      {RandomPoints.Users.PointsServer, interval: 1000 * 60 * 1}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RandomPoints.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RandomPointsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
