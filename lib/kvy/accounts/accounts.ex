defmodule Kvy.Accounts do
  alias Ecto.Multi

  alias Kvy.Repo
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
    result =
      Multi.new()
      |> Multi.run(:create_user, fn _, _ ->
        UserRepo.create_user(user_params)
      end)
      |> Multi.run(:generate_otp_key, fn _, %{create_user: user} ->
        UserRepo.generate_otp_key(user.id)
      end)
      |> Repo.transaction()

    case result do
      {:ok, %{generate_otp_key: user}} ->
        {:ok, user}

      {:error, _, reason, _} ->
        {:error, reason}
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
