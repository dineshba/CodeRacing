defmodule CodeRacing.ChallengesController do
  use CodeRacing.Web, :controller

  def index(conn, params) do
    challenges = CodeRacing.Challenges.get_all
    render(conn, "index.json", challenges: challenges)
  end
end
