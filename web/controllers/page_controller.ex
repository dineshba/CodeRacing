defmodule CodeRacing.PageController do
  use CodeRacing.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
