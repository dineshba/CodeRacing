defmodule CodeRacing.ChallengesController do
  use CodeRacing.Web, :controller

  def index(conn, params) do
    %{current_challenge: current_player_challenge} = conn.assigns.current_player
    challenge = CodeRacing.Challenges.get_challenge(current_player_challenge)
    render(conn, "index.json", challenge: challenge)
  end
end
