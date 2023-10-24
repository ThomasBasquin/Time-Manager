defmodule Server.Repo.Migrations.AddRelation do
  use Ecto.Migration

  def change do
    alter table(:working_times) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
    alter table(:clocks) do
      add :user_id, references(:users, on_delete: :delete_all)
    end
  end
end
