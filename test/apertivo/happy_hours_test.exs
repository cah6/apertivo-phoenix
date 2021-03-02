defmodule Apertivo.HappyHoursTest do
  use Apertivo.DataCase

  alias Apertivo.HappyHours

  describe "happy_hours" do
    alias Apertivo.HappyHours.HappyHour

    @valid_attrs %{city: "some city", latLng: %{}, link: "some link", place_id: "some place_id", restaurant: "some restaurant", schedule: []}
    @update_attrs %{city: "some updated city", latLng: %{}, link: "some updated link", place_id: "some updated place_id", restaurant: "some updated restaurant", schedule: []}
    @invalid_attrs %{city: nil, latLng: nil, link: nil, place_id: nil, restaurant: nil, schedule: nil}

    def happy_hour_fixture(attrs \\ %{}) do
      {:ok, happy_hour} =
        attrs
        |> Enum.into(@valid_attrs)
        |> HappyHours.create_happy_hour()

      happy_hour
    end

    test "list_happy_hours/0 returns all happy_hours" do
      happy_hour = happy_hour_fixture()
      assert HappyHours.list_happy_hours() == [happy_hour]
    end

    test "get_happy_hour!/1 returns the happy_hour with given id" do
      happy_hour = happy_hour_fixture()
      assert HappyHours.get_happy_hour!(happy_hour.id) == happy_hour
    end

    test "create_happy_hour/1 with valid data creates a happy_hour" do
      assert {:ok, %HappyHour{} = happy_hour} = HappyHours.create_happy_hour(@valid_attrs)
      assert happy_hour.city == "some city"
      assert happy_hour.latLng == %{}
      assert happy_hour.link == "some link"
      assert happy_hour.place_id == "some place_id"
      assert happy_hour.restaurant == "some restaurant"
      assert happy_hour.schedule == []
    end

    test "create_happy_hour/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = HappyHours.create_happy_hour(@invalid_attrs)
    end

    test "update_happy_hour/2 with valid data updates the happy_hour" do
      happy_hour = happy_hour_fixture()
      assert {:ok, %HappyHour{} = happy_hour} = HappyHours.update_happy_hour(happy_hour, @update_attrs)
      assert happy_hour.city == "some updated city"
      assert happy_hour.latLng == %{}
      assert happy_hour.link == "some updated link"
      assert happy_hour.place_id == "some updated place_id"
      assert happy_hour.restaurant == "some updated restaurant"
      assert happy_hour.schedule == []
    end

    test "update_happy_hour/2 with invalid data returns error changeset" do
      happy_hour = happy_hour_fixture()
      assert {:error, %Ecto.Changeset{}} = HappyHours.update_happy_hour(happy_hour, @invalid_attrs)
      assert happy_hour == HappyHours.get_happy_hour!(happy_hour.id)
    end

    test "delete_happy_hour/1 deletes the happy_hour" do
      happy_hour = happy_hour_fixture()
      assert {:ok, %HappyHour{}} = HappyHours.delete_happy_hour(happy_hour)
      assert_raise Ecto.NoResultsError, fn -> HappyHours.get_happy_hour!(happy_hour.id) end
    end

    test "change_happy_hour/1 returns a happy_hour changeset" do
      happy_hour = happy_hour_fixture()
      assert %Ecto.Changeset{} = HappyHours.change_happy_hour(happy_hour)
    end
  end
end
