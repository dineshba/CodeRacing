defmodule CodeRacing.ChallengesController do
  use CodeRacing.Web, :controller

  plug :validate_and_populate_player

  def index(conn, _params) do
    %{challenge_id: challenge_id} = conn.assigns.current_player
    challenge = CodeRacing.Challenges.get(challenge_id)
    render(conn, "index.json", challenge: challenge)
  end

  def input(conn, _params) do
    %{challenge_id: challenge_id} = conn.assigns.current_player
    %{inputOutputs: problems} = CodeRacing.Challenges.get(challenge_id)
    random_problem = problems |> Enum.random
    CodeRacing.Player.update_problem(conn.assigns.current_player_id, Map.put(random_problem, :requested_time, DateTime.utc_now))
    render(conn, "input.json", input: random_problem.input)
  end

  def create(conn, %{"output" => output}) do
    %{problem: %{output: expected_output, requested_time: requested_time}} = conn.assigns.current_player
    formatted_output = for {key, val} <- output, into: %{}, do: {String.to_atom(key), val}
    validate_and_render(conn, DateTime.diff(DateTime.utc_now, requested_time) =< 2, Poison.encode(expected_output) == Poison.encode(formatted_output))
  end

  defp validate_and_render(conn, false, _), do: bad_request_with(conn, "Time out!!!.. Try again")
  defp validate_and_render(conn, true, false), do: bad_request_with(conn, "Error!!!.. Try again")
  defp validate_and_render(conn, true, true) do
    CodeRacing.Player.move_to_next_challenge(conn.assigns.current_player_id)
    render(conn, "output.json", output: "Success!!!... Try next one")
  end

  defp bad_request_with(conn, message), do: conn |> put_status(:bad_request) |> render("output.json", output: message)

  defp validate_and_populate_player(conn, _params) do
    current_player_id = conn.assigns.current_player_id
    %{challenge_id: current_player_challenge} = current_player = CodeRacing.Player.get_details(current_player_id)
    if current_player_challenge > CodeRacing.Challenges.number_of_challenges do
      render(conn, "all_challenges_done.json") |> halt
    else
      Plug.Conn.assign(conn, :current_player, current_player)
    end
  end
end
