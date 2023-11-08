defmodule Server.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add :name, :string
      add :managers, {:array, :integer}

      timestamps(type: :utc_datetime)
    end
  end
end
