defmodule CodeRacing.PlayersManager do
  use GenServer
  import Supervisor.Spec

  def start_link(_args) do
    GenServer.start_link __MODULE__, [], name: __MODULE__
  end

  def add(%{name: player_name, key: uuid}) do
    initial_challenge_id = 1
    # CodeRacing.Endpoint.broadcast("room:lobby", "state_changed", %{body: %{player_name: name, challenge_id: initial_challenge_id}})
    GenServer.call __MODULE__, {:add_player, %{name: player_name, key: uuid, challenge_id: initial_challenge_id}}
  end

  def is_valid(player_id) do
    GenServer.call __MODULE__, {:is_valid, player_id}
  end

  def handle_call(:get_all, _from, current_players) do
    {:reply, current_players, current_players}
  end

  def handle_call({:is_valid, player_id}, _from, current_players) do
    {:reply, Enum.any?(current_players, fn player -> player == player_id end), current_players}
  end

  def handle_call({:add_player, %{name: player_name, key: key} = player_details}, _from, current_players) do
    player_id = hash(key, player_name)
    player = worker(CodeRacing.Player, [player_details, player_id], id: player_id)
    {:ok, _pid} = Supervisor.start_child(CodeRacing.PlayersSupervisor, player)
    current_players = current_players ++ [player_id]
    {:reply, current_players , current_players}
  end

  def hash(key, player_name) do
    :crypto.hash(:sha256, [key, player_name])
        |> Base.encode64
        |> String.slice(0, 5)
        |> String.to_atom
  end

end
