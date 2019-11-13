defmodule KvyWeb.AuthPlug do
  import Plug.Conn

  alias Kvy.Accounts.UserRepo
  alias Kvy.Utils.Jwt

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         {:ok, claims} <- Jwt.verify_and_validate(token),
         {:ok, id} <- Jwt.get_id_from_claims(claims),
         {:ok, user} <- UserRepo.get_user(id) do
      assign(conn, :current_user, user)
    else
      _ ->
        unauthorized(conn)
    end
  end

  def get_current_user(conn) do
    conn.assigns[:current_user]
  end

  defp unauthorized(conn) do
    conn
    |> put_status(:unauthorized)
    |> Phoenix.Controller.render(KvyWeb.ErrorView, "401.json")
    |> halt()
  end
end