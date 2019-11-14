defmodule KvyWeb.LikeController do
  use KvyWeb, :controller

  alias Kvy.Twitter
  alias Kvy.Twitter.TweetRepo
  alias KvyWeb.AuthPlug

  plug AuthPlug when action in [:create, :delete]

  def create(conn, %{"like" => %{"tweet_id" => tweet_id}}) do
    current_user = AuthPlug.get_current_user(conn)

    with {:ok, tweet} <- TweetRepo.get_tweet(tweet_id),
         {:ok, like} <- Twitter.like(current_user, tweet) do
      conn
      |> put_status(:created)
      |> render("show.json", like: like)
    end
  end

  def delete(conn, %{"like" => %{"tweet_id" => tweet_id}}) do
    current_user = AuthPlug.get_current_user(conn)

    with {:ok, tweet} <- TweetRepo.get_tweet(tweet_id),
         {:ok, like} <- Twitter.unlike(current_user, tweet) do
      conn
      |> put_status(:ok)
      |> render("show.json", like: like)
    end
  end
end
