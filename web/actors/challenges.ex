defmodule CodeRacing.Challenges do
  use GenServer

  def start_link(challenges) do
    GenServer.start_link(__MODULE__, challenges, name: __MODULE__)
  end

  def get_all do
    GenServer.call __MODULE__, :get_all
  end

  def add(%{challenge: challenge}) do
    GenServer.cast __MODULE__, {:add_new, challenge}
  end

  def handle_call(:get_all, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:add_new, challenge}, current_state) do
    {:noreply, current_state ++ [challenge]}
  end

end
