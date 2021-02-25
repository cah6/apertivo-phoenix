defmodule PhoenixGoogleMapTestWeb.PageLive do
  import PhoenixLiveReact

  use PhoenixGoogleMapTestWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    map_api_key =
      Application.get_env(:phoenix_google_map_test, PhoenixGoogleMapTestWeb.Endpoint)[
        :google_maps_api_key
      ]

    {:ok, assign(socket, query: "", results: %{}, map_api_key: map_api_key)}
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

  @impl true
  def handle_event("suggest", %{"q" => query}, socket) do
    {:noreply, assign(socket, results: search(query), query: query)}
  end

  @impl true
  def handle_event("search", %{"q" => query}, socket) do
    case search(query) do
      %{^query => vsn} ->
        {:noreply, redirect(socket, external: "https://hexdocs.pm/#{query}/#{vsn}")}

      _ ->
        {:noreply,
         socket
         |> put_flash(:error, "No dependencies found matching \"#{query}\"")
         |> assign(results: %{}, query: query)}
    end
  end

  defp search(query) do
    if not PhoenixGoogleMapTestWeb.Endpoint.config(:code_reloader) do
      raise "action disabled when not in development"
    end

    for {app, desc, vsn} <- Application.started_applications(),
        app = to_string(app),
        String.starts_with?(app, query) and not List.starts_with?(desc, ~c"ERTS"),
        into: %{},
        do: {app, vsn}
  end
end
