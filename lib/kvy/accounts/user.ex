defmodule Kvy.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kvy.Utils.PasswordHash

  schema "users" do
    field :username, :string
    field :password_hash, :string, source: :password
    field :otp_key, :string

    # virtual
    field :password, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:username, min: 6)
    |> validate_length(:password, min: 8)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  def otp_enabled?(%__MODULE__{otp_key: nil}) do
    false
  end

  def otp_enabled?(%__MODULE__{otp_key: _otp_key}) do
    true
  end

  # hashing password before putting into database
  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    changeset
    |> change(%{password_hash: PasswordHash.hash(password)})
    |> delete_change(:password)
  end

  defp put_password_hash(changeset), do: changeset
end
