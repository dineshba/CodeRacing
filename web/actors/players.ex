defmodule CodeRacing.Players do
  use GenServer

  def start_link(players) do
    GenServer.start __MODULE__, players, name: __MODULE__
  end

  def add(%{name: _name, key: _uuid} = player) do
    GenServer.call __MODULE__, {:new_player, player}
  end

  def get_by(player_name) do
    GenServer.call __MODULE__, {:get_player, player_name}
  end

  def handle_call({:new_player, player}, _from, current_players) do
    new_players = current_players ++ [player]
    {:reply, new_players, new_players}
  end

  def handle_call({:get_player, player_name}, _from, current_players) do
    required_player = current_players |> Enum.find(fn player -> player.name == player_name end)
    {:reply, required_player, current_players}
  end
end
