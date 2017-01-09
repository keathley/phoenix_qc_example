defmodule PhoenixQcExample.PageController do
  use PhoenixQcExample.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
