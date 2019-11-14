defmodule KvyWeb.TweetView do
  use KvyWeb, :view

  alias KvyWeb.UserView

  def render("index.json", %{tweets: tweets}) do
    %{data: render_many(tweets, __MODULE__, "tweet.json")}
  end

  def render("create.json", %{tweet: tweet}) do
    %{data: render_one(tweet, __MODULE__, "tweet.json")}
  end

  def render("tweet.json", %{tweet: %Ecto.Association.NotLoaded{}}) do
    nil
  end

  def render("tweet.json", %{tweet: tweet}) do
    %{
      id: tweet.id,
      text: tweet.text,
      user: render_one(tweet.user, UserView, "user.json"),
      like_count: tweet.like_count,
      retweet_count: tweet.retweet_count,
      original_tweet: render_one(tweet.original_tweet, __MODULE__, "tweet.json")
    }
  end

  def render("tweet.json", _assign) do
    nil
  end
end
