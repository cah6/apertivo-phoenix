defmodule ApertivoWeb.PageLive do
  import PhoenixLiveReact

  use ApertivoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    map_api_key = Application.get_env(:apertivo, ApertivoWeb.Endpoint)[:google_maps_api_key]

    results =
      File.read!("results.json")
      |> Jason.decode!()

    socket =
      socket
      |> assign(
        map_api_key: map_api_key,
        all_results: results,
        visible_results: [],
        selected: nil
      )

    {:ok, socket}
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

  defp filter_results(all, bounds) do
    %{"south" => s, "north" => n, "east" => e, "west" => w} = bounds

    Enum.filter(all, fn hh ->
      lat = hh["latLng"]["latitude"]
      lng = hh["latLng"]["longitude"]
      lat > s && lat < n && lng > w && lng < e
    end)
  end
end
