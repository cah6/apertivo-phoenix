defmodule Apertivo.HappyHours.HappyHour do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "happy_hours" do
    field :city, :string
    field :latLng, :map
    field :link, :string
    field :place_id, :string
    field :restaurant, :string
    field :schedule, {:array, :map}

    timestamps()
  end

  @doc false
  def changeset(happy_hour, attrs) do
    happy_hour
    |> cast(attrs, [:link, :restaurant, :place_id, :schedule, :latLng, :city])
    |> validate_required([:link, :restaurant, :place_id, :schedule, :latLng, :city])
  end
end
