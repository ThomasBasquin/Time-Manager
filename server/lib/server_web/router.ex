defmodule ServerWeb.Router do
  alias Erl2exVendored.Results.Collector
  use ServerWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", ServerWeb do
    pipe_through(:api)
    # users routes

    post("/users", UserController, :create)
    put("/users/:id", UserController, :update)
    delete("/users/:id", UserController, :delete)

    get("/users/:id", UserController, :index)
    get("/users", UserController, :index)

    # workingTime routes

    post("/workingtimes", WorkingTimeController, :create)
    put("/workingtimes/:id", WorkingTimeController, :update)
    delete("/workingtimes/:id", WorkingTimeController, :delete)

    get("/workingtimes/:user_id/:id", WorkingTimeController, :show)
    get("/workingtimes/:user_id", WorkingTimeController, :show)
    get("/workingtimes", WorkingTimeController, :show)

    # clocks routes

    post("/clocks/:id", ClockController, :create)
    put("clocks/:id", ClockController, :update)

    get("/clocks/:id", ClockController, :show)
  end

  scope "/api/swagger" do
    forward("/", PhoenixSwagger.Plug.SwaggerUI,
      otp_app: :server,
      swagger_file: "swagger.json"
    )
  end

  def swagger_info do
    %{
      info: %{
        version: "1.0",
        title: "My App"
      }
    }
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through([:fetch_session, :protect_from_forgery])

      live_dashboard("/dashboard", metrics: ServerWeb.Telemetry)
      forward("/mailbox", Plug.Swoosh.MailboxPreview)
    end
  end
end
