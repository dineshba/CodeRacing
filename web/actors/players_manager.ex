defmodule CodeRacing.PlayersManager do
  use GenServer
  import Supervisor.Spec

  def start_link(_args) do
    GenServer.start_link __MODULE__, [], name: __MODULE__
  end

  def add(%{name: player_name, key: uuid}) do
    current_challenge_for_new_player = 1
    # CodeRacing.Endpoint.broadcast("room:lobby", "state_changed", %{body: %{player_name: name, current_challenge: current_challenge_for_new_player}})
    GenServer.call __MODULE__, {:add_player, %{name: player_name, key: uuid, current_challenge: current_challenge_for_new_player}}
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
    player_id = :crypto.hash(:sha256, [key, player_name])
        |> Base.encode64
        |> String.slice(0, 5)
        |> String.to_atom
    player = worker(CodeRacing.Player, [player_details, player_id], id: player_id)
    {:ok, _pid} = Supervisor.start_child(CodeRacing.PlayersSupervisor, player)
    current_players = current_players ++ [player_id]
    {:reply, current_players , current_players}
  end

end
