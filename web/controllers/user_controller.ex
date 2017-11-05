defmodule CodeRacing.UserController do
  use CodeRacing.Web, :controller

  def create(conn, %{"user" => %{"name" => username}}) do
    user = %{name: username, key: UUID.uuid1()}
    CodeRacing.Players.add(user)
    render(conn, "success.json", user: user)
  end

end
