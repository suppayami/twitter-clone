defmodule Kvy.Utils.Otp do
  # TODO: encrypt key when storing into database

  def generate_key(length \\ 16) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode32()
    |> binary_part(0, length)
  end

  def generate_token(secret) do
    :pot.totp(secret)
  end

  def validate_token(_token, nil) do
    {:ok}
  end

  def validate_token(token, secret) do
    case :pot.valid_totp(token, secret, window: 1) do
      true ->
        {:ok}

      false ->
        {:error, :unauthorized}
    end
  end
end
