defmodule KvyWeb.RetweetController do
  use KvyWeb, :controller

  alias Kvy.Twitter
  alias Kvy.Twitter.TweetRepo
  alias KvyWeb.AuthPlug

  plug AuthPlug when action in [:create, :delete]

  def create(conn, %{"like" => %{"tweet_id" => tweet_id}}) do
    current_user = AuthPlug.get_current_user(conn)

    with {:ok, tweet} <- TweetRepo.get_tweet(tweet_id),
         {:ok, retweet} <- Twitter.retweet(current_user, tweet) do
      conn
      |> put_status(:created)
      |> render("show.json", retweet: retweet)
    end
  end

  def delete(conn, %{"like" => %{"tweet_id" => tweet_id}}) do
    current_user = AuthPlug.get_current_user(conn)

    with {:ok, tweet} <- TweetRepo.get_tweet(tweet_id),
         {:ok, retweet} <- Twitter.unretweet(current_user, tweet) do
      conn
      |> put_status(:ok)
      |> render("show.json", retweet: retweet)
    end
  end
end
