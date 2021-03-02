defmodule Apertivo.Repo.Migrations.CreateHappyHours do
  use Ecto.Migration

  def change do
    create table(:happy_hours, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :link, :string
      add :restaurant, :string
      add :place_id, :string
      add :schedule, {:array, :map}
      add :latLng, :map
      add :city, :string

      timestamps()
    end

  end
end
