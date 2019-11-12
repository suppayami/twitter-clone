defmodule Kvy.Utils.PasswordHash do
  @doc """
  Hashes a password.

  Returns an :ok|error tuple.
  """
  @spec hash(String.t()) :: String.t()
  def hash(password) when is_binary(password) do
    Argon2.hash_pwd_salt(password)
  end

  @doc """
  Verify a password against hash.
  """
  @spec verify(String.t(), String.t()) :: {:ok} | {:error, Atom.t()}
  def verify(_, nil), do: {:error, :no_hash}

  def verify(password, hash) do
    case Argon2.verify_pass(password, hash) do
      true ->
        {:ok}

      false ->
        {:error, :verify_hash_failed}
    end
  end
end
