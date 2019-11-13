defmodule Kvy.AccountsTest do
  use Kvy.DataCase

  describe "accounts" do
    alias Kvy.Accounts

    @valid_attrs %{username: "testuser", password: "testuser"}
    @invalid_attrs %{username: "baduser", password: "badpassword"}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.register()

      user
    end

    test "authenticate/1 returns token on succeed" do
      _user = user_fixture()

      assert {:ok, %{token: token}} = Accounts.authenticate(@valid_attrs)
      assert token != ""
    end

    test "authenticate/1 returns error on authenticate failed" do
      _user = user_fixture()

      assert {:error, :unauthorized} = Accounts.authenticate(@invalid_attrs)
    end
  end
end
