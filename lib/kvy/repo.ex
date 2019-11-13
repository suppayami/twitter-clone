defmodule Kvy.Repo do
  use Ecto.Repo,
    otp_app: :kvy,
    adapter: Ecto.Adapters.Postgres

  @doc """
  Returns a record from queryable.

  Returns a tuple :ok|error
  """
  def get_one(queryable) do
    case queryable |> one() do
      nil ->
        {:error, :not_found}

      result ->
        {:ok, result}
    end
  end
end
