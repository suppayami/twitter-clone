defmodule KvyWeb.TweetControllerTest do
  use KvyWeb.ConnCase

  alias Kvy.Accounts
  alias Kvy.Accounts.UserRepo
  alias Kvy.Twitter.TweetRepo

  @valid_attrs %{text: "Test Tweet"}
  @invalid_attrs %{test: nil}

  @user_attrs %{username: "testuser", password: "testuser"}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> UserRepo.create_user()

    user
  end

  def tweet_fixture(user, attrs \\ %{}) do
    fixture_attrs = Enum.into(attrs, @valid_attrs)
    {:ok, tweet} = TweetRepo.create_tweet(user, fixture_attrs)

    tweet
  end

  test "index/2 responds all tweets", %{conn: conn} do
    user = user_fixture()
    tweet = tweet_fixture(user)
    tweet_2 = tweet_fixture(user)

    response =
      conn
      |> get(Routes.tweet_path(conn, :index))
      |> json_response(:ok)

    _expected = %{
      "data" => [
        %{"id" => tweet.id, "text" => "Test Tweet"},
        %{"id" => tweet_2.id, "text" => "Test Tweet"}
      ]
    }

    assert _expected = response
  end

  test "create/2 responds created tweet", %{conn: conn} do
    _user = user_fixture()

    {:ok, %{token: token}} =
      @user_attrs
      |> Map.put(:otp, "")
      |> Accounts.authenticate()

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> post(Routes.tweet_path(conn, :create), %{tweet: @valid_attrs})
      |> json_response(:created)

    assert %{"data" => %{"text" => _text}} = response
  end

  test "create/2 responds with bad request on invalid attrs", %{conn: conn} do
    _user = user_fixture()

    {:ok, %{token: token}} =
      @user_attrs
      |> Map.put(:otp, "")
      |> Accounts.authenticate()

    conn
    |> put_req_header("authorization", "Bearer #{token}")
    |> post(Routes.tweet_path(conn, :create), %{tweet: @invalid_attrs})
    |> json_response(:bad_request)
  end

  test "create/2 responds unauthorized if not authenticated", %{conn: conn} do
    conn
    |> post(Routes.tweet_path(conn, :create), %{tweet: @valid_attrs})
    |> json_response(:unauthorized)
  end
end
