defmodule ApertivoWeb.HappyHourLive.Index do
  import PhoenixLiveReact
  use ApertivoWeb, :live_view

  alias Apertivo.HappyHours
  alias Apertivo.HappyHours.HappyHour

  @impl true
  def mount(_params, _session, socket) do
    map_api_key = Application.get_env(:apertivo, ApertivoWeb.Endpoint)[:google_maps_api_key]

    results = list_happy_hours()

    socket =
      socket
      |> assign(
        map_api_key: map_api_key,
        all_results: results,
        visible_results: results,
        selected: nil,
        filter: :filter,
        today: get_day_of_week()
      )

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Happy hour")
    |> assign(:happy_hour, HappyHours.get_happy_hour!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Happy hour")
    |> assign(:happy_hour, %HappyHour{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Happy hours")
    |> assign(:happy_hour, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    happy_hour = HappyHours.get_happy_hour!(id)
    {:ok, _} = HappyHours.delete_happy_hour(happy_hour)

    {:noreply, assign(socket, :happy_hours, list_happy_hours())}
  end

  @impl true
  def handle_event("bounds_changed", new_bounds, socket) do
    visible =
      socket.assigns()[:all_results]
      |> filter_results(new_bounds)

    visible_map_data =
      visible
      |> Enum.map(fn hh ->
        {lng, lat} = hh.location.coordinates
        %{id: hh.id, restaurant: hh.restaurant, lng: lng, lat: lat}
      end)

    socket =
      socket
      |> push_event("new_results", %{"data" => visible_map_data})
      |> assign(visible_results: visible)

    {
      :noreply,
      socket
    }
  end

  def handle_event("item_selected", %{"id" => id}, socket) do
    socket =
      socket
      |> push_event("set_selected_icon", %{"id" => id})
      |> assign(selected: id)

    {
      :noreply,
      socket
    }
  end

  def handle_event("filter", %{"filter" => filter}, socket) do
    socket =
      socket
      |> assign(:visible_results, filter_by_day(socket.assigns.all_results, filter["day"]))

    {:noreply, socket}
  end

  defp list_happy_hours do
    HappyHours.list_happy_hours()
  end

  defp filter_by_day(all, day) do
    Enum.filter(all, fn hh ->
      Enum.any?(hh.schedule, &schedule_has_day?(&1, day))
    end)
  end

  defp schedule_has_day?(schedule, day) do
    Enum.any?(schedule["days"], &(&1 == day))
  end

  defp filter_results(all, bounds) do
    %{"south" => s, "north" => n, "east" => e, "west" => w} = bounds

    Enum.filter(all, fn hh ->
      {lng, lat} = hh.location.coordinates
      lat > s && lat < n && lng > w && lng < e
    end)
  end

  defp daysOrdered() do
    ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  end

  defp get_day_of_week() do
    Date.utc_today()
    |> Date.day_of_week()
    |> day_num_to_string()
  end

  defp day_num_to_string(day_num) do
    case day_num do
      1 -> "Monday"
      2 -> "Tuesday"
      3 -> "Wednesday"
      4 -> "Thursday"
      5 -> "Friday"
      6 -> "Saturday"
      7 -> "Sunday"
    end
  end
end
