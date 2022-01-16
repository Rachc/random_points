defmodule RandomPoints.Users.PointsServer do
  @moduledoc """
  """
  use GenServer

  import Ecto.Query

  alias RandomPoints.Repo
  alias RandomPoints.Users.User

  ##### Client

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    initial_state = %{max_number: random_number_generator(), timestamp: nil}

    interval = Keyword.fetch!(opts, :interval)

    call_update_poins(self(), interval)

    {:ok, initial_state}
  end

  defp random_number_generator() do
    Enum.random(0..100)
  end

  defp call_update_poins(pid, interval) do
    Process.send_after(pid, {:refresh, interval}, interval)
  end

  def update_points(pid, interval) do
    GenServer.cast(pid, :update_max_number)

    update(User, set: [points: fragment("floor(random()*(0-100+1)+100)")])
    |> Repo.update_all([])

    call_update_poins(pid, interval)
  end

  def get_state(pid), do: GenServer.call(pid, :get_state)

  def get_users(pid), do: GenServer.call(pid, :get_users)

  ##### Server

  def handle_info({:refresh, interval}, state) do
    update_points(self(), interval)

    {:noreply, state}
  end

  def handle_cast(:update_max_number, state) do
    %{timestamp: timestamp} = state

    new_state = %{max_number: random_number_generator(), timestamp: timestamp}

    {:noreply, new_state}
  end

  def handle_call(:get_state, _from, state), do: {:reply, state, state}

  def handle_call(:get_users, _from, state) do
    %{timestamp: timestamp, max_number: max_number} = state

    users =
      User
      |> where([user], user.points > ^max_number)
      |> limit(2)
      |> Repo.all()

    filtered_users = %{users: users, timestamp: timestamp}

    now = DateTime.utc_now()

    new_state = %{max_number: max_number, timestamp: now}

    {:reply, filtered_users, new_state}
  end
end
