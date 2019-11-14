defmodule Kvy.Twitter.Retweet do
  use Ecto.Schema
  import Ecto.Changeset

  alias Kvy.Accounts.User
  alias Kvy.Twitter.Tweet

  @primary_key false
  schema "retweets" do
    belongs_to :user, User, primary_key: true
    belongs_to :tweet, Tweet, primary_key: true
  end

  def retweet(user, tweet) do
    %__MODULE__{}
    |> change()
    |> put_assoc(:user, user)
    |> put_assoc(:tweet, tweet)
  end
end
