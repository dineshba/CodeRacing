defmodule CodeRacing.RoomChannel.Stash do
  use GenServer

  def start_link(results) do
    GenServer.start_link(__MODULE__, results, name: __MODULE__)
  end

  def get_results do
    GenServer.call __MODULE__, :get_results
  end

  def update_result(value) do
    GenServer.cast __MODULE__, {:update_result, value}
  end

  def handle_call(:get_results, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update_result, value}, current_state) do
    CodeRacing.Endpoint.broadcast "room:lobby", "state_changed", %{body: value}
    {:noreply, current_state ++ [value]}
  end

end
