defmodule Server.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Server.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        username: "some username"
      })
      |> Server.Account.create_user()

    user
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2023-10-22 13:46:00],
        start: ~N[2023-10-22 13:46:00],
        user_id: 42
      })
      |> Server.Account.create_working_time()

    working_time
  end

  @doc """
  Generate a working_time.
  """
  def working_time_fixture(attrs \\ %{}) do
    {:ok, working_time} =
      attrs
      |> Enum.into(%{
        end: ~N[2023-10-22 13:48:00],
        start: ~N[2023-10-22 13:48:00],
        user_id: 42
      })
      |> Server.Account.create_working_time()

    working_time
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2023-10-23 07:47:00Z]
      })
      |> Server.Account.create_clock()

    clock
  end

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Server.Account.create_team()

    team
  end
end
