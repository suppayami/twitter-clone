defmodule Kvy.Twitter.TweetRepo do
  import Ecto.Query

  alias Kvy.Repo
  alias Kvy.Twitter.Tweet

  def create_tweet(user, tweet_params) do
    Tweet.new(user, tweet_params)
    |> Repo.insert()
  end

  def create_retweet(user, tweet, retweet_params \\ %{}) do
    Tweet.retweet(user, tweet, retweet_params)
    |> Repo.insert()
  end

  def delete_retweet(user, tweet) do
    with {:ok, tweet} <- get_retweet(user, tweet) do
      Repo.delete(tweet)
    end
  end

  def get_tweet(id) do
    Repo.get_by_id(Tweet, id)
  end

  def get_retweet(user, tweet) do
    Tweet
    |> where(user_id: ^user.id)
    |> where(retweet_id: ^tweet.id)
    |> Repo.get_one()
  end

  def list_tweets() do
    query =
      from [t] in build_list_tweets(),
        order_by: [desc: t.id]

    Repo.all(query)
  end

  def list_most_likes_tweets() do
    query =
      from [t, l, rt] in build_list_tweets(),
        order_by: [desc: fragment("like_count")]

    Repo.all(query)
  end

  defp build_list_tweets() do
    from t in Tweet,
      join: u in assoc(t, :user),
      left_join: ot in assoc(t, :original_tweet),
      preload: [user: u, original_tweet: ot],
      left_join: l in assoc(t, :likes),
      left_join: rt in assoc(t, :retweets),
      group_by: [t.id, u.id, ot.id],
      select: %{
        t
        | like_count: fragment("count(?) as like_count", l),
          retweet_count: count(rt)
      }
  end
end
