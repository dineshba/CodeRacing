defmodule CodeRacing.Challenges do
  use GenServer

  def start_link(challenges) do
    GenServer.start_link(__MODULE__, challenges, name: __MODULE__)
  end

  def get(challenge_id) do
    GenServer.call __MODULE__, {:get, challenge_id}
  end

  def number_of_challenges do
    GenServer.call __MODULE__, :number_of_challenges
  end

  def add(%{challenge: challenge}) do
    GenServer.cast __MODULE__, {:add_new, challenge}
  end

  def handle_call({:get, number}, _from, challenges) do
    {:reply, Enum.at(challenges, number - 1), challenges}
  end

  def handle_call(:number_of_challenges, _from, challenges) do
    {:reply, Enum.count(challenges), challenges}
  end

  def handle_cast({:add_new, challenge}, challenges) do
    {:noreply, challenges ++ [challenge]}
  end

end
