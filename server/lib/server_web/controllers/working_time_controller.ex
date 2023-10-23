defmodule ServerWeb.WorkingTimeController do
  use ServerWeb, :controller

  alias Server.Account
  alias Server.Account.WorkingTime

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    working_times = Account.list_working_times()
    render(conn, :index, working_times: working_times)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Account.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/working_times/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Account.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Account.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Account.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Account.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Account.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
