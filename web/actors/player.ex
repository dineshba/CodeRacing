defmodule CodeRacing.Player do
  use GenServer

  def start_link(%{name: _player_name,
                    key: _uuid,
                    current_challenge: _current_challenge
                    } = player, name) do
    GenServer.start_link __MODULE__, player, name: name
  end

  def get_details(player) do
    GenServer.call player, :details
  end

  def update_problem(player, problem) do
    GenServer.cast player, {:update_problem, problem}
  end

  def move_to_next_challenge(player) do
    GenServer.cast player, :increment_challenge
  end

  def handle_call(:details, _from, current_player) do
    {:reply, current_player, current_player}
  end

  def handle_cast({:update_problem, problem}, current_player) do
    {:noreply, Map.put(current_player, :problem, problem)}
  end

  def handle_cast(:increment_challenge, current_player) do
    {:noreply, Map.merge(current_player, %{current_challenge: 1}, fn _k, v1, v2 -> v1 + v2 end)}
  end

end
