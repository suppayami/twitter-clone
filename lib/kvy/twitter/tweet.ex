defmodule Kvy.Twitter.Tweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kvy.Accounts.User
  alias Kvy.Twitter.Like
  alias Kvy.Twitter.Retweet

  schema "tweets" do
    field :text, :string, default: ""

    # virtual
    field :like_count, :integer, default: 0, virtual: true
    field :retweet_count, :integer, default: 0, virtual: true

    # relationships
    belongs_to :user, User
    has_many :likes, Like
    has_many :retweets, Retweet

    # retweets
    belongs_to :original_tweet, __MODULE__, foreign_key: :retweet_id
    has_many :retweet_tweets, __MODULE__, foreign_key: :retweet_id

    timestamps()
  end

  def new(user, attrs \\ %{}) do
    changeset(%__MODULE__{}, attrs)
    |> put_assoc(:user, user)
  end

  def retweet(user, tweet, attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:text])
    |> put_assoc(:user, user)
    |> put_assoc(:original_tweet, tweet)
  end

  defp changeset(changeset, attrs) do
    changeset
    |> cast(attrs, [:text])
    |> validate_required([:text])
    |> validate_length(:text, min: 1, max: 160)
  end
end
