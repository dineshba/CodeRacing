defmodule CodeRacing.UserController do
  use CodeRacing.Web, :controller

  def create(conn, %{"user" => %{"name" => player_name}}) do
    user = %{name: player_name, key: UUID.uuid1()}
    CodeRacing.PlayersManager.add(user)
    render(conn, "success.json", user: user)
  end

end
