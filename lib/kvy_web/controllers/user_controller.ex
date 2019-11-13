defmodule KvyWeb.UserController do
  use KvyWeb, :controller

  alias Kvy.Accounts
  alias Kvy.Accounts.UserRepo

  def index(conn, _params) do
    users = UserRepo.list_users()
    render(conn, "index.json", %{users: users})
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register(user_params) do
      conn
      |> put_status(:created)
      |> render("create.json", %{user: user})
    end
  end
end
