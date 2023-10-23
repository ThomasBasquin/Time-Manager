defmodule Server.Account.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  schema "working_times" do
    field :start, :naive_datetime
    field :end, :naive_datetime
    field :user_id, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:user_id, :start, :end])
    |> validate_required([:user_id, :start, :end])
  end
end
