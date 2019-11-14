defmodule KvyWeb.SessionView do
  use KvyWeb, :view

  alias KvyWeb.UserView

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("create.json", %{token: token}) do
    %{data: %{token: token}}
  end

  def render("otp.json", %{otp: otp}) do
    %{data: %{otp: otp}}
  end
end
