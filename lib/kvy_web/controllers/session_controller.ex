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
    credentials =
      Transformer.map_keys_to_atom(user)
      |> Map.put_new(:otp, "")

    with {:ok, data} <- Accounts.authenticate(credentials) do
      conn
      |> put_status(:created)
      |> render("create.json", data)
    end
  end

  def delete(conn, _params) do
    # TODO: Blacklist token
    current_user = AuthPlug.get_current_user(conn)
    render(conn, "show.json", %{user: current_user})
  end

  def otp(conn, %{"id" => id}) do
    with {:ok, otp} <- Accounts.generate_otp(id) do
      render(conn, "otp.json", %{otp: otp})
    end
  end
end
