defmodule ServerWeb.ClockController do
  use ServerWeb, :controller

  alias Server.Account
  alias Server.Account.Clock

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    clocks = Account.list_clocks()
    clocks_with_users = Server.Repo.preload(clocks, :user)

    response_list =
      Enum.map(clocks_with_users, fn clock ->
        %{
          "id" => clock.id,
          "time" => clock.time,
          "status" => clock.status,
          "user_id" => clock.user_id,
          "user" => %{
            "username" => clock.user.username,
            "email" => clock.user.email
          }
        }
      end)

    conn
    |> put_status(:ok)
    |> json(response_list)
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Account.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Account.get_clock!(id)
    clock_with_user = Server.Repo.preload(clock, :user)

    response = %{
      "id" => clock_with_user.id,
      "time" => clock_with_user.time,
      "status" => clock_with_user.status,
      "user_id" => clock_with_user.user_id,
      "user" => %{
        "username" => clock_with_user.user.username,
        "email" => clock_with_user.user.email
      }
    }

    conn
    |> put_status(:ok)
    |> json(response)
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Account.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Account.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Account.get_clock!(id)

    with {:ok, %Clock{}} <- Account.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
