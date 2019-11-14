defmodule KvyWeb.SessionControllerTest do
  use KvyWeb.ConnCase

  alias Kvy.Accounts
  alias Kvy.Accounts.UserRepo

  @valid_attrs %{username: "testuser", password: "testuser", otp: ""}
  @invalid_attrs %{username: "baduser", password: "badpassword", otp: ""}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> UserRepo.create_user()

    user
  end

  test "show/2 responds unauthorized if no valid token found", %{conn: conn} do
    conn
    |> get(Routes.session_path(conn, :show))
    |> json_response(:unauthorized)
  end

  test "show/2 responds current user with valid token found", %{conn: conn} do
    user = user_fixture()
    {:ok, %{token: token}} = Accounts.authenticate(@valid_attrs)

    response =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> get(Routes.session_path(conn, :show))
      |> json_response(:ok)

    _expected = %{"data" => %{"id" => user.id, "username" => user.username}}
    assert _expected = response
  end

  test "create/2 responds authorization token if authenticated", %{conn: conn} do
    _user = user_fixture()

    response =
      conn
      |> post(Routes.session_path(conn, :create), %{user: @valid_attrs})
      |> json_response(:created)

    assert %{"data" => %{"token" => _token}} = response
  end

  test "create/2 responds unauthorized if not authenticated", %{conn: conn} do
    conn
    |> post(Routes.session_path(conn, :create), %{user: @invalid_attrs})
    |> json_response(:unauthorized)
  end
end
