defmodule Kvy.AccountsTest do
  use Kvy.DataCase

  describe "accounts" do
    alias Kvy.Accounts
    alias Kvy.Utils.Otp

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
      user = user_fixture()
      otp = Otp.generate_token(user.otp_key)
      credentials = Map.put_new(@valid_attrs, :otp, otp)

      assert {:ok, %{token: token}} = Accounts.authenticate(credentials)
      assert token != ""
    end

    test "authenticate/1 returns error on authenticate failed" do
      user = user_fixture()
      otp = Otp.generate_token(user.otp_key)
      credentials = Map.put_new(@invalid_attrs, :otp, otp)

      assert {:error, :unauthorized} = Accounts.authenticate(credentials)
    end

    test "authenticate/1 returns error on otp authenticated failed" do
      _user = user_fixture()
      credentials = Map.put_new(@valid_attrs, :otp, "")

      assert {:error, :unauthorized} = Accounts.authenticate(credentials)
    end
  end
end

QVLVRUPPM4SZMWAABWGU
MFRGGZDFMZTWQ2LK
