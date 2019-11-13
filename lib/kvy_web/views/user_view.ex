defmodule KvyWeb.UserView do
  use KvyWeb, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, __MODULE__, "user.json")}
  end

  def render("create.json", %{user: user}) do
    %{data: render_one(user, __MODULE__, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end
end
