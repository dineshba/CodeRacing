defmodule CodeRacing.UserView do
  use CodeRacing.Web, :view

  def render("success.json", %{user: user}) do
    %{
      name: user.name,
      key: user.key
    }
  end
end
