defmodule KvyWeb.Router do
  use KvyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KvyWeb do
    pipe_through :api

    resources "/user/", UserController, only: [:index, :create]
    resources "/session/", SessionController, only: [:index, :create, :delete]
  end
end
