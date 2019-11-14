defmodule Kvy.Twitter.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kvy.Accounts.User

  schema "tweets" do
    field :text, :string, default: ""
    field :like_count, :integer, default: 0
    field :retweet_count, :integer, default: 0

    # relationships
    belongs_to :user, User

    timestamps()
  end

  def new(user, attrs \\ %{}) do
    changeset(%__MODULE__{}, attrs)
    |> put_assoc(:user, user)
  end

  defp changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text, min: 1, max: 160)
  end
end
