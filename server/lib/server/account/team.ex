defmodule Server.Account.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    field :managers, {:array, :integer}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name, :managers])
    |> validate_required([:name, :managers])
  end
end
