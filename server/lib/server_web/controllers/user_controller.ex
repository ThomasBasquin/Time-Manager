defmodule ServerWeb.UserController do
  use ServerWeb, :controller
  use PhoenixSwagger
  import Plug.Conn.Status, only: [code: 1]
  import Ecto.Query

  alias Server.Account
  alias Server.Account.User

  action_fallback(ServerWeb.FallbackController)
  # Ajout de la route GET /api/users
  swagger_path :index do
    get("/api/users")
    description("List of users")
    parameter(:query, :string, :id, "Filter by id")
    response(code(:ok), "Success")
  end

  def login(conn, %{"email" => email, "password" => password}) do
    # Recherchez l'utilisateur par e-mail
    user = Account.get_user_by_email!(email)

    case user do
      nil ->
        # L'utilisateur n'existe pas
        conn
        |> put_status(404)
        |> json(%{error: "Utilisateur non trouvé"})

      %User{password: password_hash, id: user_id, role: user_role} ->
        # Vérifiez le mot de passe en utilisant Pbkdf2.verify_pass
        if Pbkdf2.verify_pass(password, password_hash) do
          xsrf_token = :crypto.strong_rand_bytes(32) |> Base.encode64()
          jwt = ServerWeb.JWTManager.create_token(user_id, user_role, xsrf_token)
          response = %{message: "Connexion réussie", xsrf_token: xsrf_token}
          # Mot de passe correct, vous pouvez effectuer une action de connexion ici
          conn
          |> put_status(200)
          |> Plug.Conn.put_resp_cookie("jwt", jwt, http_only: true, secure: true)
          |> json(response)
        else
          conn
          |> put_status(401)
          |> json(%{error: "Mot de passe incorrect"})
        end
    end
  end

  def index(conn, _params) do
    users = Account.list_users(_params)
    render(conn, :index, users: users)
  end

  swagger_path :create do
    post("/api/users")
    description("Create a user")
    parameter(:body, :user, :body, "User to create", required: true)
    response(code(:created), "Success")
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  swagger_path :show do
    get("/api/users/{id}")
    description("Show a user")
    parameter(:path, :string, :id, "User id", required: true)
    response(code(:ok), "Success")
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, :show, user: user)
  end

  swagger_path :update do
    put("/api/users/{id}")
    description("Update a user")
    parameter(:path, :string, :id, "User id", required: true)
    parameter(:body, :user, :body, "User to update", required: true)
    response(code(:ok), "Success")
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  swagger_path :delete do
    PhoenixSwagger.Path.delete("/api/users/{id}")
    description("Delete a user")
    parameter(:path, :string, :id, "User id", required: true)
    response(code(:no_content), "Success")
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
