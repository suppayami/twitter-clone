defmodule Kvy.Twitter.TweetRepo do
  import Ecto.Query

  alias Kvy.Repo
  alias Kvy.Twitter.Tweet

  def create_tweet(user, tweet_params) do
    Tweet.new(user, tweet_params)
    |> Repo.insert()
  end

  def get_tweet(id) do
    Repo.get_by_id(Tweet, id)
  end

  def list_tweets() do
    Repo.all(Tweet)
  end
end
