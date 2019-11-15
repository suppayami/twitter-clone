defmodule Kvy.Utils.Jwt do
  use Joken.Config

  # 24 hours
  @session_exp 60 * 60 * 24
  @id_field "id"

  def token_config do
    default_claims(skip: [:aud], iss: "Kvy")
  end

  def generate_user_token(user_id) do
    generate_and_sign(%{"exp" => current_time() + @session_exp, @id_field => user_id})
  end

  def get_id_from_claims(claims) do
    case Map.get(claims, @id_field) do
      nil -> {:error, :no_id}
      id -> {:ok, id}
    end
  end
end
