defmodule Kvy.Accounts do
  alias Kvy.Accounts.UserRepo
  alias Kvy.Utils.{PasswordHash, Jwt, Otp}

  @doc """
  Authenticate using credentials.

  Returns a tuple of :ok|error.
  """
  def authenticate(%{username: username, password: password, otp: otp}) do
    with {:ok, user} <- UserRepo.get_user_by_username(username),
         {:ok} <- PasswordHash.verify(password, user.password_hash),
         {:ok} <- Otp.validate_token(otp, user.otp_key),
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
    # TODO: Maybe not enable OTP by default
    with {:ok, user} <- UserRepo.create_user(user_params) do
      UserRepo.generate_otp_key(user.id)
    end
  end

  @doc """
  Generate OTP for user ID, for testing purpose.

  Returns a tuple of :ok|error.
  """
  def generate_otp(user_id) do
    with {:ok, user} <- UserRepo.get_user(user_id) do
      {:ok, Otp.generate_token(user.otp_key)}
    end
  end
end
