defmodule CodeRacing.Players do
  use GenServer

  def start_link(players) do
    GenServer.start __MODULE__, players, name: __MODULE__
  end

  def add(%{name: name, key: uuid}) do
    current_challenge_for_new_player = 1
    CodeRacing.Endpoint.broadcast("room:lobby", "state_changed", %{body: %{player_name: name, current_challenge: current_challenge_for_new_player}})
    GenServer.call __MODULE__, {:new_player, %{name: name, key: uuid, current_challenge: current_challenge_for_new_player}}
  end

  def get_all do
    GenServer.call __MODULE__, :get_all
  end

  def get_by(player_name) do
    GenServer.call __MODULE__, {:get_player, player_name}
  end

  def move_to_next_challenge(player) do
    GenServer.cast __MODULE__, {:increment_challenge, player}
  end

  def update_problem(player, problem) do
    GenServer.cast __MODULE__, {:update_problem, player, problem}
  end

  def handle_call(:get_all, _from, current_players) do
    {:reply, current_players, current_players}
  end

  def handle_call({:new_player, player}, _from, current_players) do
    new_players = current_players ++ [player]
    {:reply, new_players, new_players}
  end

  def handle_call({:get_player, player_name}, _from, current_players) do
    required_player = current_players |> Enum.find(fn player -> player.name == player_name end)
    {:reply, required_player, current_players}
  end

  def handle_cast({:increment_challenge, %{key: current_player_key}}, current_players) do
    current_players = current_players |> Enum.map(fn player ->
      case player.key do
        current_player_key -> increment_challenge_for(player)
                        _  -> player
      end
    end)
    {:noreply, current_players}
  end

  def handle_cast({:update_problem, %{key: current_player_key}, problem}, current_players) do
    current_players = current_players |> Enum.map(fn player ->
      case player.key do
        current_player_key -> Map.put(player, :problem, problem)
                        _  -> player
      end
    end)
    {:noreply, current_players}
  end

  defp increment_challenge_for(player) do
    Map.merge(player, %{current_challenge: 1}, fn _k, v1, v2 -> v1 + v2 end)
  end
end
