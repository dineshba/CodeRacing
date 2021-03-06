defmodule CodeRacing.PlayersSupervisor do
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link __MODULE__, [], name: __MODULE__
  end

  def init(_arg) do
    Supervisor.init([
      {CodeRacing.PlayersManager, []}
    ], strategy: :one_for_one)
  end
end
