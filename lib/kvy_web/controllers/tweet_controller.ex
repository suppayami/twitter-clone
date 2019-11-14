defmodule KvyWeb.TweetController do
  use KvyWeb, :controller

  alias Kvy.Twitter.TweetRepo
  alias KvyWeb.AuthPlug

  plug AuthPlug when action in [:create]

  def index(conn, %{"order_by" => "like_count"}) do
    tweets = TweetRepo.list_tweets(desc: :like_count)
    render(conn, "index.json", %{tweets: tweets})
  end

  def index(conn, _params) do
    tweets = TweetRepo.list_tweets()
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
