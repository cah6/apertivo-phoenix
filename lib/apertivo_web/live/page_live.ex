defmodule ApertivoWeb.PageLive do
  import PhoenixLiveReact

  use ApertivoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    map_api_key = Application.get_env(:apertivo, ApertivoWeb.Endpoint)[:google_maps_api_key]

    results =
      File.read!("results.json")
      |> Jason.decode!()

    {:ok, assign(socket, map_api_key: map_api_key, all_results: results, visible_results: %{})}
  end

  @impl true
  def handle_event("bounds_changed", new_bounds, socket) do
    visible =
      socket.assigns()[:all_results]
      |> filter_results(new_bounds)

    socket =
      socket
      |> push_event("new_results", %{"data" => visible})
      |> assign(visible_results: visible)

    {
      :noreply,
      socket
    }
  end

  defp filter_results(all, bounds) do
    %{"south" => s, "north" => n, "east" => e, "west" => w} = bounds

    Enum.filter(all, fn hh ->
      lat = hh["latLng"]["latitude"]
      lng = hh["latLng"]["longitude"]
      lat > s && lat < n && lng > w && lng < e
    end)
  end

  defp daysOrdered() do
    ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  end

  defp abbreviate(day) do
    case day do
      "Sunday" -> "S"
      "Monday" -> "M"
      "Tuesday" -> "T"
      "Wednesday" -> "W"
      "Thursday" -> "T"
      "Friday" -> "F"
      "Saturday" -> "S"
    end
  end
end
