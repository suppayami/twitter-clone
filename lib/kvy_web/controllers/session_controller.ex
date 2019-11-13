defmodule KvyWeb.SessionController do
  use KvyWeb, :controller

  alias Kvy.Accounts
  alias Kvy.Utils.Transformer
  alias KvyWeb.AuthPlug

  plug AuthPlug when action in [:show, :delete]

  def show(conn, _params) do
    current_user = AuthPlug.get_current_user(conn)
    render(conn, "show.json", %{user: current_user})
  end

  def create(conn, %{"user" => user}) do
    with {:ok, data} <- Accounts.authenticate(Transformer.map_keys_to_atom(user)) do
      render(conn, "create.json", data)
    end
  end

  def delete(conn, _params) do
    # TODO: Blacklist token
    current_user = AuthPlug.get_current_user(conn)
    render(conn, "show.json", %{user: current_user})
  end
end
