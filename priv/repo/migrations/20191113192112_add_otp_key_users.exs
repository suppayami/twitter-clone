defmodule Kvy.Repo.Migrations.AddOtpKeyUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :otp_key, :string, null: true
    end
  end
end
