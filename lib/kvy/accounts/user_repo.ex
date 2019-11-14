defmodule Kvy.Accounts.UserRepo do
  import Ecto.Query

  alias Kvy.Repo
  alias Kvy.Accounts.User
  alias Kvy.Utils.Otp

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

  def get_user(id) do
    Repo.get_by_id(User, id)
  end

  def list_users() do
    Repo.all(User)
  end

  def generate_otp_key(id) do
    with {:ok, user} <- get_user(id) do
      otp_key = Otp.generate_key()

      user
      |> Ecto.Changeset.change(%{otp_key: otp_key})
      |> Repo.update()
    end
  end
end
