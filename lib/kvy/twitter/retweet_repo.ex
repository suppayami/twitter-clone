defmodule Kvy.Twitter.RetweetRepo do
  import Ecto.Query

  alias Kvy.Repo
  alias Kvy.Twitter.Retweet

  def retweet(user, tweet) do
    Retweet.retweet(user, tweet)
    |> Repo.insert()
  end

  def unretweet(user, tweet) do
    with {:ok, retweet} <- get_retweet(user, tweet) do
      Repo.delete(retweet)
    end
  end

  def get_retweet(user, tweet) do
    Like
    |> where(user_id: ^user.id)
    |> where(tweet_id: ^tweet.id)
    |> Repo.get_one()
  end
end
