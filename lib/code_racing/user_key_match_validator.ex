defmodule CodeRacing.UserKeyMatchValidator do
  import Plug.Conn

  alias CodeRacing.PlayersManager

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
        current_player_id = PlayersManager.hash(key, player_name)
        if PlayersManager.is_valid(current_player_id) do
          Plug.Conn.assign(conn, :current_player_id, current_player_id)
        else
          conn |> send_resp(:unauthorized, "username and key mismatch") |> halt
        end
      end
    end
  end
end
