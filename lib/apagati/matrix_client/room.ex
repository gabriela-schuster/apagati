defmodule Apagati.MatrixClient.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:title])
    |> validate_required([:title])
  end
end
