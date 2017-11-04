defmodule CodeRacing.RoomChannel do
  use Phoenix.Channel

  def join("room:lobby", _message, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    CodeRacing.RoomChannel.Stash.get_results |> Enum.each(fn result ->
        push socket, "state_changed", %{body: result} end)
    {:noreply, socket}
  end

end
