defmodule KvyWeb.UserController do
  use KvyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json")
  end

  def create(conn, _params) do
  end
end
