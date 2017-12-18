defmodule CodeRacing.ChallengesView do
  use CodeRacing.Web, :view

  def render("index.json", %{challenge: challenge}) do
    %{
      name: challenge.name,
      sampleInput: challenge.sample_input,
      sampleOutput: challenge.sample_output,
    }
  end

  def render("all_challenges_done.json", _params) do
    "You are done with all your challenges"
  end

  def render("input.json", %{input: input}) do
    %{
      input: input
    }
  end

  def render("output.json", %{output: output}) do
    %{
      output: output
    }
  end

end
