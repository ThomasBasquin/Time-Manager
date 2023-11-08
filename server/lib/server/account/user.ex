defmodule Server.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string
    field :role, :string
    field :teams, {:array, :integer}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :role, :teams])
    |> validate_required([:email, :username, :password, :role, :teams])
    # Ajout de la contrainte d'unicité sur "username"
    |> unique_constraint(:username)
    # Ajout de la contrainte d'unicité sur "email"
    |> unique_constraint(:email)
  end
end
