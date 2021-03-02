defmodule ApertivoWeb.HappyHourLiveTest do
  use ApertivoWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Apertivo.HappyHours

  @create_attrs %{city: "some city", latLng: %{}, link: "some link", place_id: "some place_id", restaurant: "some restaurant", schedule: []}
  @update_attrs %{city: "some updated city", latLng: %{}, link: "some updated link", place_id: "some updated place_id", restaurant: "some updated restaurant", schedule: []}
  @invalid_attrs %{city: nil, latLng: nil, link: nil, place_id: nil, restaurant: nil, schedule: nil}

  defp fixture(:happy_hour) do
    {:ok, happy_hour} = HappyHours.create_happy_hour(@create_attrs)
    happy_hour
  end

  defp create_happy_hour(_) do
    happy_hour = fixture(:happy_hour)
    %{happy_hour: happy_hour}
  end

  describe "Index" do
    setup [:create_happy_hour]

    test "lists all happy_hours", %{conn: conn, happy_hour: happy_hour} do
      {:ok, _index_live, html} = live(conn, Routes.happy_hour_index_path(conn, :index))

      assert html =~ "Listing Happy hours"
      assert html =~ happy_hour.city
    end

    test "saves new happy_hour", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.happy_hour_index_path(conn, :index))

      assert index_live |> element("a", "New Happy hour") |> render_click() =~
               "New Happy hour"

      assert_patch(index_live, Routes.happy_hour_index_path(conn, :new))

      assert index_live
             |> form("#happy_hour-form", happy_hour: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#happy_hour-form", happy_hour: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.happy_hour_index_path(conn, :index))

      assert html =~ "Happy hour created successfully"
      assert html =~ "some city"
    end

    test "updates happy_hour in listing", %{conn: conn, happy_hour: happy_hour} do
      {:ok, index_live, _html} = live(conn, Routes.happy_hour_index_path(conn, :index))

      assert index_live |> element("#happy_hour-#{happy_hour.id} a", "Edit") |> render_click() =~
               "Edit Happy hour"

      assert_patch(index_live, Routes.happy_hour_index_path(conn, :edit, happy_hour))

      assert index_live
             |> form("#happy_hour-form", happy_hour: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#happy_hour-form", happy_hour: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.happy_hour_index_path(conn, :index))

      assert html =~ "Happy hour updated successfully"
      assert html =~ "some updated city"
    end

    test "deletes happy_hour in listing", %{conn: conn, happy_hour: happy_hour} do
      {:ok, index_live, _html} = live(conn, Routes.happy_hour_index_path(conn, :index))

      assert index_live |> element("#happy_hour-#{happy_hour.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#happy_hour-#{happy_hour.id}")
    end
  end

  describe "Show" do
    setup [:create_happy_hour]

    test "displays happy_hour", %{conn: conn, happy_hour: happy_hour} do
      {:ok, _show_live, html} = live(conn, Routes.happy_hour_show_path(conn, :show, happy_hour))

      assert html =~ "Show Happy hour"
      assert html =~ happy_hour.city
    end

    test "updates happy_hour within modal", %{conn: conn, happy_hour: happy_hour} do
      {:ok, show_live, _html} = live(conn, Routes.happy_hour_show_path(conn, :show, happy_hour))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Happy hour"

      assert_patch(show_live, Routes.happy_hour_show_path(conn, :edit, happy_hour))

      assert show_live
             |> form("#happy_hour-form", happy_hour: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#happy_hour-form", happy_hour: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.happy_hour_show_path(conn, :show, happy_hour))

      assert html =~ "Happy hour updated successfully"
      assert html =~ "some updated city"
    end
  end
end
