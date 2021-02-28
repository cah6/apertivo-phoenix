defmodule ApertivoWeb.PageLive do
  import PhoenixLiveReact

  use ApertivoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    map_api_key = Application.get_env(:apertivo, ApertivoWeb.Endpoint)[:google_maps_api_key]

    results =
      File.read!("results.json")
      |> Jason.decode!()

    {:ok, assign(socket, map_api_key: map_api_key, results: results)}
  end

  @impl true
  def handle_event("bounds_changed", new_bounds, socket) do
    %{"south" => s, "north" => n, "east" => e, "west" => w} = new_bounds
    lat1 = rand_float(s, n)
    lng1 = rand_float(w, e)

    {
      :noreply,
      push_event(socket, "new_map_items", %{
        a: %{lat: lat1, lng: lng1}
        # b: %{lat: rand_float(south, north), lng: rand_float(west, east)}
      })
    }
  end

  defp rand_float(min, max) do
    :random.uniform() * (max - min) + min
  end
end
