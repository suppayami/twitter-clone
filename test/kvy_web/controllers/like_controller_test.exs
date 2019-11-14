defmodule KvyWeb.LikeControllerTest do
  use KvyWeb.ConnCase

  alias Kvy.Accounts
  alias Kvy.Twitter
  alias Kvy.Twitter.TweetRepo
  alias Kvy.Accounts.UserRepo

  @tweet_attrs %{text: "good text"}
  @user_attrs %{username: "testuser", password: "testuser", otp: ""}

  def user_fixture do
    {:ok, user} = UserRepo.create_user(@user_attrs)
    user
  end

  def tweet_fixtures(user) do
    {:ok, tweet_1} = TweetRepo.create_tweet(user, @tweet_attrs)
    {:ok, tweet_2} = TweetRepo.create_tweet(user, @tweet_attrs)
    {:ok, tweet_3} = TweetRepo.create_tweet(user, @tweet_attrs)

    {:ok, _like} = Twitter.like(user, tweet_2)
    {:ok, _retweet} = Twitter.retweet(user, tweet_2)

    [tweet_1, tweet_2, tweet_3]
  end

  describe "create like" do
    test "creates like when tweet is likeable", %{conn: conn} do
      user = user_fixture()
      tweets = tweet_fixtures(user)
      {:ok, %{token: token}} = Accounts.authenticate(@user_attrs)

      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> post(Routes.like_path(conn, :create), %{like: %{tweet_id: List.first(tweets).id}})
      |> json_response(:created)
    end

    test "renders errors when tweet is not likeable", %{conn: conn} do
      user = user_fixture()
      tweets = tweet_fixtures(user)
      {:ok, %{token: token}} = Accounts.authenticate(@user_attrs)

      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> post(Routes.like_path(conn, :create), %{like: %{tweet_id: Enum.at(tweets, 1).id}})
      |> json_response(:bad_request)
    end
  end

  describe "delete like" do
    test "deletes like if user already liked tweet", %{conn: conn} do
      user = user_fixture()
      tweets = tweet_fixtures(user)
      {:ok, %{token: token}} = Accounts.authenticate(@user_attrs)

      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> delete(Routes.like_path(conn, :delete), %{like: %{tweet_id: Enum.at(tweets, 1).id}})
      |> json_response(:ok)
    end

    test "renders error if user haven't liked tweet", %{conn: conn} do
      user = user_fixture()
      tweets = tweet_fixtures(user)
      {:ok, %{token: token}} = Accounts.authenticate(@user_attrs)

      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> delete(Routes.like_path(conn, :delete), %{like: %{tweet_id: Enum.at(tweets, 0).id}})
      |> json_response(:bad_request)
    end
  end
end
