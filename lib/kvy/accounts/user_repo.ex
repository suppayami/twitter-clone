defmodule Kvy.Accounts.UserRepo do
  import Ecto.Query

  alias Kvy.Repo
  alias Kvy.Accounts.User

  def create_user(user_params) do
    %User{}
    |> User.changeset(user_params)
    |> Repo.insert()
  end

  def get_user_by_username(username) do
    User
    |> where(username: ^username)
    |> Repo.get_one()
  end

  def list_users() do
    Repo.all(User)
  end
end
