defmodule Server.Account.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_times" do
    field :start, :utc_datetime
    field :end, :utc_datetime

    belongs_to :user, Server.Account.User

    timestamps()
  end

  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:user_id, :start, :end])
    |> validate_required([:start, :end, :user_id])
  end
end
