defmodule ServerWeb.WorkingTimeController do
  use ServerWeb, :controller
  import Server.Repo

  alias Server.Account
  alias Server.Account.WorkingTime

  action_fallback ServerWeb.FallbackController

  def index(conn, _params) do
    working_times = Account.list_working_times()
    working_times_with_users = Server.Repo.preload(working_times, :user)

    # Transformez la liste des WorkingTime en une liste de réponses JSON
    response_list =
      Enum.map(working_times_with_users, fn working_time ->
        %{
          "id" => working_time.id,
          "start" => working_time.start,
          "end" => working_time.end,
          "user_id" => working_time.user_id,
          "user" => %{
            "id" => working_time.user.id,
            "username" => working_time.user.username,
            "email" => working_time.user.email
          }
        }
      end)

    # Renvoyez la liste de réponses JSON
    conn
    |> put_status(:ok)
    |> json(response_list)
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
    # Charger l'utilisateur associé en utilisant le préchargement
    working_time_with_user = Server.Repo.preload(working_time, :user)

    # Construire la réponse JSON
    response = %{
      "id" => working_time_with_user.id,
      "start" => working_time_with_user.start,
      "end" => working_time_with_user.end,
      "user_id" => working_time_with_user.user_id,
      "user" => %{
        "id" => working_time_with_user.user.id,
        "username" => working_time_with_user.user.username,
        "email" => working_time_with_user.user.email
      }
    }

    # Renvoyez la liste de réponses JSON
    conn
    |> put_status(:ok)
    |> json(response)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Account.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <-
           Account.update_working_time(working_time, working_time_params) do
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
