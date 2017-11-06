defmodule CodeRacing.ChallengesView do
  use CodeRacing.Web, :view

  def render("index.json", %{challenge: challenge}) do
    %{
      name: challenge.name,
      examples: render_many(challenge.examples, CodeRacing.ExampleView, "index.json")
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

defmodule CodeRacing.ExampleView do
  use CodeRacing.Web, :view

  def render("index.json", %{example: example}) do
    example
  end
end
