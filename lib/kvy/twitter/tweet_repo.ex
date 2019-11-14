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
      preload: [user: u],
      left_join: l in assoc(t, :likes),
      left_join: rt in assoc(t, :retweets),
      group_by: [t.id, u.id],
      select: %{
        t
        | like_count: fragment("count(?) as like_count", l),
          retweet_count: count(rt)
      }
  end
end
