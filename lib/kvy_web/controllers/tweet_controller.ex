defmodule KvyWeb.TweetController do
  use KvyWeb, :controller

  alias Kvy.Twitter.TweetRepo
  alias KvyWeb.AuthPlug

  plug AuthPlug when action in [:create]
  plug AuthPlug, :optional when action in [:index]

  def index(conn, %{"order_by" => "like_count"}) do
    current_user = AuthPlug.get_current_user(conn)
    tweets = TweetRepo.list_most_likes_tweets(current_user)
    render(conn, "index.json", %{tweets: tweets})
  end

  def index(conn, _params) do
    current_user = AuthPlug.get_current_user(conn)
    tweets = TweetRepo.list_tweets(current_user)
    render(conn, "index.json", %{tweets: tweets})
  end

  def create(conn, %{"tweet" => tweet_params}) do
    current_user = AuthPlug.get_current_user(conn)

    with {:ok, tweet} <- TweetRepo.create_tweet(current_user, tweet_params) do
      conn
      |> put_status(:created)
      |> render("create.json", %{tweet: tweet})
    end
  end
end
