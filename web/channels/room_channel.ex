defmodule CodeRacing.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    # CodeRacing.Players.get_all |> Enum.each(fn player ->
        # push socket, "state_changed", %{body: %{player_name: player.name, challenge_id: player.current_challenge}} end)
    {:noreply, socket}
  end

end
