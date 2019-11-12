defmodule KvyWeb.Router do
  use KvyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", KvyWeb do
    pipe_through :api
  end
end
