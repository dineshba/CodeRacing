defmodule CodeRacing.Challenges do
  use GenServer

  def start_link(challenges) do
    GenServer.start_link(__MODULE__, challenges, name: __MODULE__)
  end

  def get_challenge(number) do
    GenServer.call __MODULE__, {:get_challenge, number}
  end

  def add(%{challenge: challenge}) do
    GenServer.cast __MODULE__, {:add_new, challenge}
  end

  def handle_call({:get_challenge, number}, _from, challenges) do
    {:reply, Enum.at(challenges, number - 1), challenges}
  end

  def handle_cast({:add_new, challenge}, current_challenges) do
    {:noreply, current_challenges ++ [challenge]}
  end

end
