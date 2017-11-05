defmodule CodeRacing.UserKeyMatchValidator do
  import Plug.Conn

  def init(options), do: options

  def call(conn, _opts) do
    if conn.path_info == ["register"] do
      conn
    else
      key = List.first(get_req_header(conn, "key"))
      player_name = List.first(get_req_header(conn, "username"))

      if key == nil || player_name == nil do
        conn |> send_resp(:unauthorized, "key and/or username is missing in request headers") |> halt
      else
        required_player = CodeRacing.Players.get_by(player_name)
        if required_player != nil and required_player.key == key do
          conn
        else
          conn |> send_resp(:unauthorized, "username and key mismatch") |> halt
        end
      end
    end
  end
end
