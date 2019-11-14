defmodule Kvy.TwitterTest do
  use Kvy.DataCase

  describe "twitter" do
    alias Kvy.Twitter
    alias Kvy.Twitter.{Like, Tweet, TweetRepo}
    alias Kvy.Accounts.UserRepo

    @valid_attrs %{text: "good text"}
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
      {:ok, _retweet} = Twitter.retweet(user, tweet_2)

      [tweet_1, tweet_2, tweet_3]
    end

    test "like/2 returns bad request if user already liked tweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert {:error, :bad_request} = Twitter.like(user, Enum.at(tweets, 1))
    end

    test "like/2 returns a new like on a tweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert {:ok, %Like{}} = Twitter.like(user, Enum.at(tweets, 0))
    end

    test "unlike/2 returns bad request if user didn't like tweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert {:error, :bad_request} = Twitter.unlike(user, Enum.at(tweets, 0))
    end

    test "unlike/2 unlike an already-liked tweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert {:ok, %Like{}} = Twitter.unlike(user, Enum.at(tweets, 1))
    end

    test "retweet/2 returns bad request if user already retweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert {:error, :bad_request} = Twitter.retweet(user, Enum.at(tweets, 1))
    end

    test "retweet/2 returns a new retweet on a tweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)
      tweet = Enum.at(tweets, 0)

      assert {:ok, %Tweet{}} = Twitter.retweet(user, tweet)
    end

    test "unretweet/2 returns bad request if user didn't retweet tweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert {:error, :bad_request} = Twitter.unretweet(user, Enum.at(tweets, 0))
    end

    test "unretweet/2 unlike an already-retweeted tweet" do
      user = user_fixture()
      tweets = tweet_fixtures(user)
      tweet = Enum.at(tweets, 1)

      assert {:ok, %Tweet{}} = Twitter.unretweet(user, tweet)
    end
  end
end
