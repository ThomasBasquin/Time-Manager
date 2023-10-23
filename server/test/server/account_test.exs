defmodule Server.AccountTest do
  use Server.DataCase

  alias Server.Account

  describe "users" do
    alias Server.Account.User

    import Server.AccountFixtures

    @invalid_attrs %{username: nil, email: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Account.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Account.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{username: "some username", email: "some email"}

      assert {:ok, %User{} = user} = Account.create_user(valid_attrs)
      assert user.username == "some username"
      assert user.email == "some email"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{username: "some updated username", email: "some updated email"}

      assert {:ok, %User{} = user} = Account.update_user(user, update_attrs)
      assert user.username == "some updated username"
      assert user.email == "some updated email"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_user(user, @invalid_attrs)
      assert user == Account.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Account.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Account.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Account.change_user(user)
    end
  end

  describe "working_times" do
    alias Server.Account.WorkingTime

    import Server.AccountFixtures

    @invalid_attrs %{start: nil, end: nil, user_id: nil}

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert Account.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Account.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2023-10-22 13:46:00], end: ~N[2023-10-22 13:46:00], user_id: 42}

      assert {:ok, %WorkingTime{} = working_time} = Account.create_working_time(valid_attrs)
      assert working_time.start == ~N[2023-10-22 13:46:00]
      assert working_time.end == ~N[2023-10-22 13:46:00]
      assert working_time.user_id == 42
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~N[2023-10-23 13:46:00], end: ~N[2023-10-23 13:46:00], user_id: 43}

      assert {:ok, %WorkingTime{} = working_time} = Account.update_working_time(working_time, update_attrs)
      assert working_time.start == ~N[2023-10-23 13:46:00]
      assert working_time.end == ~N[2023-10-23 13:46:00]
      assert working_time.user_id == 43
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_working_time(working_time, @invalid_attrs)
      assert working_time == Account.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Account.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Account.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Account.change_working_time(working_time)
    end
  end

  describe "working_times" do
    alias Server.Account.WorkingTime

    import Server.AccountFixtures

    @invalid_attrs %{start: nil, end: nil, user_id: nil}

    test "list_working_times/0 returns all working_times" do
      working_time = working_time_fixture()
      assert Account.list_working_times() == [working_time]
    end

    test "get_working_time!/1 returns the working_time with given id" do
      working_time = working_time_fixture()
      assert Account.get_working_time!(working_time.id) == working_time
    end

    test "create_working_time/1 with valid data creates a working_time" do
      valid_attrs = %{start: ~N[2023-10-22 13:48:00], end: ~N[2023-10-22 13:48:00], user_id: 42}

      assert {:ok, %WorkingTime{} = working_time} = Account.create_working_time(valid_attrs)
      assert working_time.start == ~N[2023-10-22 13:48:00]
      assert working_time.end == ~N[2023-10-22 13:48:00]
      assert working_time.user_id == 42
    end

    test "create_working_time/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Account.create_working_time(@invalid_attrs)
    end

    test "update_working_time/2 with valid data updates the working_time" do
      working_time = working_time_fixture()
      update_attrs = %{start: ~N[2023-10-23 13:48:00], end: ~N[2023-10-23 13:48:00], user_id: 43}

      assert {:ok, %WorkingTime{} = working_time} = Account.update_working_time(working_time, update_attrs)
      assert working_time.start == ~N[2023-10-23 13:48:00]
      assert working_time.end == ~N[2023-10-23 13:48:00]
      assert working_time.user_id == 43
    end

    test "update_working_time/2 with invalid data returns error changeset" do
      working_time = working_time_fixture()
      assert {:error, %Ecto.Changeset{}} = Account.update_working_time(working_time, @invalid_attrs)
      assert working_time == Account.get_working_time!(working_time.id)
    end

    test "delete_working_time/1 deletes the working_time" do
      working_time = working_time_fixture()
      assert {:ok, %WorkingTime{}} = Account.delete_working_time(working_time)
      assert_raise Ecto.NoResultsError, fn -> Account.get_working_time!(working_time.id) end
    end

    test "change_working_time/1 returns a working_time changeset" do
      working_time = working_time_fixture()
      assert %Ecto.Changeset{} = Account.change_working_time(working_time)
    end
  end
end
