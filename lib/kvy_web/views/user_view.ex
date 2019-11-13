defmodule KvyWeb.UserView do
  use KvyWeb, :view

  def render("index.json", _params) do
    %{ok: :ok}
  end
end
