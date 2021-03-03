# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Apertivo.Repo.insert!(%Apertivo.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule X do
  alias Apertivo.HappyHours.HappyHour

  def convert(json) do
    %HappyHour{
      city: json["city"],
      location: %Geo.Point{
        coordinates: {json["latLng"]["longitude"], json["latLng"]["latitude"]},
        srid: 4326
      },
      link: json["link"],
      place_id: json["placeId"],
      restaurant: json["restaurant"],
      schedule: json["schedule"]
    }
  end
end

results =
  File.read!("results.json")
  |> Jason.decode!()
  |> Enum.map(fn hh -> X.convert(hh) end)
  |> Enum.each(fn hh -> Apertivo.Repo.insert!(hh) end)
