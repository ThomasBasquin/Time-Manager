defmodule Server.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :username, :string

      timestamps(type: :utc_datetime)
    end

    execute("CREATE UNIQUE INDEX users_username_index ON users (username)")
    execute("CREATE UNIQUE INDEX users_email_index ON users (email)")
  end
end
