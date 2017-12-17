defmodule CodeRacing.RoomChannel do
  use Phoenix.Channel

  alias CodeRacing.PlayersManager
  alias CodeRacing.Player
  alias CodeRacing.Challenges

  def join("code_racing:track", _message, socket) do
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    push socket, "no_of_challenges", %{body: %{number_of_challenges: Challenges.number_of_challenges}}
    PlayersManager.get_all |> Enum.each(fn player_id ->
        player = Player.get_details(player_id)
        push socket, "new_player", %{body: %{player_name: player.name, challenge_id: player.challenge_id, key: player.key}} end)
    {:noreply, socket}
  end

end
