defmodule KvyWeb.RetweetView do
  use KvyWeb, :view

  def render("show.json", %{retweet: retweet}) do
    %{data: render_one(retweet, __MODULE__, "retweet.json")}
  end

  def render("retweet.json", %{retweet: retweet}) do
    %{tweet_id: retweet.tweet_id, user_id: retweet.user_id}
  end
end
