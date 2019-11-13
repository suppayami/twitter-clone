defmodule KvyWeb.FallbackController do
  use KvyWeb, :controller

  alias KvyWeb.ErrorView

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)

    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json", %{errors: errors})
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.json")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
  end
end
