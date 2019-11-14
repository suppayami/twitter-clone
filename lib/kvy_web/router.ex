defmodule KvyWeb.Router do
  use KvyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KvyWeb do
    pipe_through :api

    resources "/user/", UserController, only: [:index, :create]
    resources "/session/", SessionController, only: [:show, :create, :delete], singleton: true
    get "/session/otp/:id", SessionController, :otp
    resources "/tweet/", TweetController, only: [:index, :create]
  end
end
