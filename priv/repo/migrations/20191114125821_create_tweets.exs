defmodule Kvy.Repo.Migrations.CreateTweets do
  use Ecto.Migration

  def change do
    create table(:tweets) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :text, :string, null: false

      timestamps()
    end

    create table(:likes, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :tweet_id, references(:tweets, on_delete: :delete_all), primary_key: true
    end

    create table(:retweets, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all), primary_key: true
      add :tweet_id, references(:tweets, on_delete: :delete_all), primary_key: true
    end
  end
end
