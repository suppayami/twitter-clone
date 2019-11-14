defmodule KvyWeb.RetweetView do
  use KvyWeb, :view

  alias KvyWeb.TweetView

  def render("show.json", %{retweet: retweet}) do
    %{data: render_one(retweet, TweetView, "tweet.json")}
  end
end
