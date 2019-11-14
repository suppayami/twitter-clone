defmodule KvyWeb.LikeView do
  use KvyWeb, :view

  def render("show.json", %{like: like}) do
    %{data: render_one(like, __MODULE__, "like.json")}
  end

  def render("like.json", %{like: like}) do
    %{tweet_id: like.tweet_id, user_id: like.user_id}
  end
end
