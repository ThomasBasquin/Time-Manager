defmodule ServerWeb.ClockController do
  use ServerWeb, :controller
  use PhoenixSwagger
  import Plug.Conn.Status, only: [code: 1]

  alias Server.Account
  alias Server.Account.Clock

  action_fallback ServerWeb.FallbackController

  swagger_path :index do
    get("/api/clocks")
    description("List of clocks")
    parameter(:query, :string, :id, "Filter by id")
    response(code(:ok), "Success")
  end

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

  swagger_path :create do
    post("/api/clocks")
    description("Create a clock")
    parameter(:body, :clock, :body, "Clock to create", required: true)
    response(code(:created), "Success")
  end

  def create(conn, %{"clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Account.create_clock(clock_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/clocks/#{clock}")
      |> render(:show, clock: clock)
    end
  end

  swagger_path :show do
    get("/api/clocks/{id}")
    description("Show a clock")
    parameter(:path, :string, :id, "Clock id", required: true)
    response(code(:ok), "Success")
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

  swagger_path :update do
    put("/api/clocks/{id}")
    description("Update a clock")
    parameter(:path, :string, :id, "Clock id", required: true)
    parameter(:body, :clock, :body, "Clock to update", required: true)
    response(code(:ok), "Success")
  end

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Account.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Account.update_clock(clock, clock_params) do
      render(conn, :show, clock: clock)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/clocks/{id}")
    description("Delete a clock")
    parameter(:path, :string, :id, "Clock id", required: true)
    response(code(:no_content), "Success")
  end

  def delete(conn, %{"id" => id}) do
    clock = Account.get_clock!(id)

    with {:ok, %Clock{}} <- Account.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
end
