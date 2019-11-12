defmodule Kvy.Repo do
  use Ecto.Repo,
    otp_app: :kvy,
    adapter: Ecto.Adapters.Postgres
end
