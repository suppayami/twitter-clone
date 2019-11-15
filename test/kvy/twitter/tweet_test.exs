defmodule Kvy.Twitter.TweetTest do
  use Kvy.DataCase

  describe "tweets" do
    alias Kvy.Twitter
    alias Kvy.Twitter.{Tweet, TweetRepo}
    alias Kvy.Accounts.{UserRepo}

    @valid_attrs %{text: "good text"}
    @invalid_attrs %{text: nil}

    @user_attrs %{username: "testuser", password: "testuser"}

    def user_fixture do
      {:ok, user} = UserRepo.create_user(@user_attrs)
      user
    end

    def tweet_fixtures(user) do
      {:ok, tweet_1} = TweetRepo.create_tweet(user, @valid_attrs)
      {:ok, tweet_2} = TweetRepo.create_tweet(user, @valid_attrs)
      {:ok, tweet_3} = TweetRepo.create_tweet(user, @valid_attrs)

      {:ok, _like} = Twitter.like(user, tweet_2)

      [tweet_1, tweet_2, tweet_3]
    end

    test "TweetRepo.create_tweet/2 with valid data creates a tweet" do
      user = user_fixture()
      assert {:ok, %Tweet{}} = TweetRepo.create_tweet(user, @valid_attrs)
    end

    test "TweetRepo.create_tweet/2 with invalid data returns error" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = TweetRepo.create_tweet(user, @invalid_attrs)
    end

    test "TweetRepo.list_tweets/0 lists all tweets" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert Enum.count(TweetRepo.list_tweets(user)) == Enum.count(tweets)
    end

    test "TweetRepo.list_most_likes_tweets/0 lists all tweets in most liked order" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      list_tweets = TweetRepo.list_most_likes_tweets()

      assert Enum.count(list_tweets) == Enum.count(tweets)
      assert List.first(list_tweets).id == Enum.at(tweets, 1).id
    end
  end
end
