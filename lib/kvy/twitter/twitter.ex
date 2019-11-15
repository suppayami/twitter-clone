defmodule Kvy.Twitter do
  alias Ecto.Multi

  alias Kvy.Repo
  alias Kvy.Twitter.LikeRepo
  alias Kvy.Twitter.RetweetRepo
  alias Kvy.Twitter.TweetRepo

  def like(user, tweet) do
    with {:ok} <- likeable?(user, tweet) do
      LikeRepo.like(user, tweet)
    end
  end

  def unlike(user, tweet) do
    with {:ok} <- unlikeable?(user, tweet) do
      LikeRepo.unlike(user, tweet)
    end
  end

  def retweet(user, tweet) do
    with {:ok} <- retweetable?(user, tweet) do
      retweet_transaction(user, tweet)
    end
  end

  def unretweet(user, tweet) do
    with {:ok} <- unretweetable?(user, tweet) do
      unretweet_transaction(user, tweet)
    end
  end

  defp likeable?(user, tweet) do
    LikeRepo.get_like(user, tweet)
    |> actionable?
  end

  defp unlikeable?(user, tweet) do
    LikeRepo.get_like(user, tweet)
    |> unactionable?
  end

  defp retweetable?(user, tweet) do
    RetweetRepo.get_retweet(user, tweet)
    |> actionable?
  end

  defp unretweetable?(user, tweet) do
    RetweetRepo.get_retweet(user, tweet)
    |> unactionable?
  end

  defp actionable?(result) do
    case result do
      {:ok, _} ->
        {:error, :bad_request}

      {:error, :not_found} ->
        {:ok}
    end
  end

  defp unactionable?(result) do
    case result do
      {:ok, _} ->
        {:ok}

      {:error, :not_found} ->
        {:error, :bad_request}
    end
  end

  defp retweet_transaction(user, tweet) do
    result =
      Multi.new()
      |> Multi.run(:retweet, fn _, _ ->
        RetweetRepo.retweet(user, tweet)
      end)
      |> Multi.run(:tweet, fn _, _ ->
        TweetRepo.create_retweet(user, tweet)
      end)
      |> Repo.transaction()

    case result do
      {:ok, %{tweet: tweet}} ->
        {:ok, tweet}

      {:error, _, reason, _} ->
        {:error, reason}
    end
  end

  defp unretweet_transaction(user, tweet) do
    result =
      Multi.new()
      |> Multi.run(:retweet, fn _, _ ->
        RetweetRepo.unretweet(user, tweet)
      end)
      |> Multi.run(:tweet, fn _, _ ->
        TweetRepo.delete_retweet(user, tweet)
      end)
      |> Repo.transaction()

    case result do
      {:ok, %{tweet: tweet}} ->
        {:ok, tweet}

      {:error, _, reason, _} ->
        {:error, reason}
    end
  end
end
