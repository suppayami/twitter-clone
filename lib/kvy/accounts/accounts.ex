defmodule Kvy.Accounts do
  alias Kvy.Accounts.UserRepo
  alias Kvy.Utils.{PasswordHash, Jwt}

  @doc """
  Authenticate using credentials.

  Returns a tuple of :ok|error.
  """
  def authenticate(%{username: username, password: password}) do
    with {:ok, user} <- UserRepo.get_user_by_username(username),
         {:ok} <- PasswordHash.verify(password, user.password_hash),
         {:ok, token, _} <- Jwt.generate_user_token(user.id) do
      {:ok, %{token: token}}
    else
      {:error, :not_found} ->
        {:error, :unauthorized}

      error ->
        error
    end
  end

  @doc """
  Create an user using given user params.

  Returns a tuple of :ok|error.
  """
  def register(user_params) do
    UserRepo.create_user(user_params)
  end
end
