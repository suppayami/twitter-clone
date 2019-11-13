defmodule KvyWeb.UserControllerTest do
  use KvyWeb.ConnCase

  alias Kvy.Accounts.UserRepo

  @valid_attrs %{username: "testuser", password: "testuser"}
  @invalid_attrs %{username: "", password: ""}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@valid_attrs)
      |> UserRepo.create_user()

    user
  end

  test "index/2 responds with all Users", %{conn: conn} do
    user1 = user_fixture(%{username: "testuser1"})
    user2 = user_fixture(%{username: "testuser2"})

    response =
      conn
      |> get(Routes.user_path(conn, :index))
      |> json_response(:ok)

    _expectced = %{
      "data" => [
        %{"id" => user1.id, "username" => user1.username},
        %{"id" => user2.id, "username" => user2.username}
      ]
    }

    assert expectced = response
  end

  test "create/2 creates new user and responds with that created user", %{conn: conn} do
    response =
      conn
      |> post(Routes.user_path(conn, :create), %{user: @valid_attrs})
      |> json_response(:created)

    _expected = %{"data" => %{"username" => @valid_attrs[:username]}}

    assert _expected = response["data"]["username"]
  end

  test "create/2 responds with bad request on invalid attrs", %{conn: conn} do
    conn
    |> post(Routes.user_path(conn, :create), %{user: @invalid_attrs})
    |> json_response(:bad_request)
  end
end
