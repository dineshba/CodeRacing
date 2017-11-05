defmodule CodeRacing.ChallengesView do
  use CodeRacing.Web, :view

  def render("index.json", %{challenges: challenges}) do
    %{
      number_of_challenges: Enum.count(challenges),
      challenges: render_many(challenges, CodeRacing.ChallengeView, "index.json")
    }
  end
end

defmodule CodeRacing.ChallengeView do
  use CodeRacing.Web, :view

  def render("index.json", %{challenge: challenge}) do
    %{
      name: challenge.name,
      examples: render_many(challenge.examples, CodeRacing.ExampleView, "index.json")
    }
  end
end

defmodule CodeRacing.ExampleView do
  use CodeRacing.Web, :view

  def render("index.json", %{example: example}) do
    example
  end
end
