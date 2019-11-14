defmodule Kvy.Repo.Migrations.AddRetweetTweet do
  use Ecto.Migration

  def change do
    alter table(:tweets) do
      add :retweet_id, references(:tweets)
    end
  end
end
