defmodule Kvy.Twitter.TweetTest do
  use Kvy.DataCase

  describe "tweets" do
    alias Kvy.Repo
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

      Repo.update(Ecto.Changeset.change(tweet_2, %{like_count: 2}))
      Repo.update(Ecto.Changeset.change(tweet_3, %{like_count: 1}))

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

    test "TweetRepo.list_tweets/1 lists all tweets" do
      user = user_fixture()
      tweets = tweet_fixtures(user)

      assert Enum.count(TweetRepo.list_tweets()) == Enum.count(tweets)
    end
  end
end
