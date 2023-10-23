defmodule Server.Repo.Migrations.CreateWorkingTimes do
  use Ecto.Migration

  def change do
    create table(:working_times) do
      add :user_id, :integer
      add :start, :naive_datetime
      add :end, :naive_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
