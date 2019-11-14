defmodule Kvy.Twitter.LikeRepo do
  import Ecto.Query

  alias Kvy.Repo
  alias Kvy.Twitter.Like

  def like(user, tweet) do
    Like.like(user, tweet)
    |> Repo.insert()
  end

  def unlike(user, tweet) do
    with {:ok, like} <- get_like(user, tweet) do
      Repo.delete(like)
    end
  end

  def get_like(user, tweet) do
    Like
    |> where(user_id: ^user.id)
    |> where(tweet_id: ^tweet.id)
    |> Repo.get_one()
  end
end
