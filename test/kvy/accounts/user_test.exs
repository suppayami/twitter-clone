defmodule Kvy.Accounts.UserTest do
  use Kvy.DataCase

  describe "users" do
    alias Kvy.Accounts.User
    alias Kvy.Accounts.UserRepo

    @valid_attrs %{username: "testuser", password: "testuser"}
    @invalid_attrs %{username: nil, password: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserRepo.create_user()

      user
    end

    test "UserRepo.list_users/0 returns all users" do
      user = user_fixture()
      assert UserRepo.list_users() == [user]
    end

    test "UserRepo.create_user/1 with valid data creates an user" do
      assert {:ok, %User{} = user} = UserRepo.create_user(@valid_attrs)
      assert user.username == "testuser"
    end

    test "UserRepo.create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@invalid_attrs)
    end

    test "UserRepo.create_user/1 should check unique username" do
      _user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = UserRepo.create_user(@valid_attrs)
    end

    test "UserRepo.create_user/1 with valid data creates an user with hashed password" do
      assert {:ok, %User{} = user} = UserRepo.create_user(@valid_attrs)
      assert user.password != "testuser"
    end

    test "UserRepo.get_user_by_username/1 returns found user" do
      user = user_fixture()
      assert {:ok, found_user} = UserRepo.get_user_by_username("testuser")
      assert found_user == user
    end

    test "UserRepo.get_user/1 returns found user" do
      user = user_fixture()
      assert {:ok, found_user} = UserRepo.get_user(user.id)
      assert found_user == user
    end
  end
end
