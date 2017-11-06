defmodule CodeRacing.ChallengesController do
  use CodeRacing.Web, :controller

  plug :all_challenges_done_check

  def index(conn, params) do
    %{current_challenge: current_player_challenge} = conn.assigns.current_player
    challenge = CodeRacing.Challenges.get(current_player_challenge)
    render(conn, "index.json", challenge: challenge)
  end

  def input(conn, params) do
    %{current_challenge: current_player_challenge} = current_player = conn.assigns.current_player
    %{problem_set: problems} = CodeRacing.Challenges.get(current_player_challenge)
    random_problem = problems |> Enum.random
    CodeRacing.Players.update_problem(current_player, random_problem)
    render(conn, "input.json", input: random_problem.input)
  end

  def create(conn, %{"output" => output}) do
    %{problem: %{output: expected_output}} = current_player = conn.assigns.current_player
    if expected_output == output do
      CodeRacing.Players.move_to_next_challenge(current_player)
      render(conn, "output.json", output: "Success!!!... Try next one")
    else
      render(conn, "output.json", output: "Error!!!.. Try again")
    end
  end

  defp all_challenges_done_check(conn, _params) do
    %{current_challenge: current_player_challenge} = current_player = conn.assigns.current_player
    if current_player_challenge > CodeRacing.Challenges.number_of_challenges do
      render(conn, "all_challenges_done.json") |> halt
    else
      conn
    end
  end
end
