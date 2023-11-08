defmodule ServerWeb.WorkingTimeController do
  use ServerWeb, :controller
  use PhoenixSwagger
  import Plug.Conn.Status, only: [code: 1]

  alias Server.Account
  alias Server.Account.WorkingTime

  action_fallback ServerWeb.FallbackController

  swagger_path :index do
    get("/api/working_times")
    description("List of working_times")
    parameter(:query, :string, :id, "Filter by id")
    response(code(:ok), "Success")
  end

  def index(conn, params) do
    working_times = Account.list_working_times(params)
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

  swagger_path :create do
    post("/api/working_times")
    description("Create a working_time")
    parameter(:body, :working_time, :body, "WorkingTime to create", required: true)
    response(code(:created), "Success")
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Account.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/working_times/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end


  def show(conn, params) do
    token = ""
    jwt = ""
    IO.inspect(get_req_header(conn, "authorization"))
    if get_req_header(conn, "authorization") != [] do
      token = Enum.at(String.split(hd(get_req_header(conn, "authorization")), " "), 1)
    end
    if get_req_header(conn, "cookie") != [] do
      jwt = Enum.at(String.split(hd(get_req_header(conn, "cookie")), "="), 1)
    end

    IO.inspect(jwt)
    IO.inspect(token)

    decrypt = ServerWeb.JWTManager.verify_token(jwt)
    xsrf_token = ""

    IO.inspect(decrypt)
    if decrypt != {:error, "Invalid token"} do
      xsrf_token = Map.get(decrypt, "xsrf_token")
    end

    if xsrf_token == token do
      working_times = Account.list_working_times(params)
      working_times_with_users = Server.Repo.preload(working_times, :user)
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
      conn
      |> put_status(:ok)
      |> json(response_list)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{"error" => "Unauthorized"})
    end

    IO.inspect(xsrf_token)
  end




  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Account.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <-
           Account.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/working_times/{id}")
    description("Delete a working_time")
    parameter(:path, :string, :id, "WorkingTime id", required: true)
    response(code(:no_content), "Success")
  end

  def delete(conn, %{"id" => id}) do
    working_time = Account.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Account.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
