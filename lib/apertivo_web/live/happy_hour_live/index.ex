defmodule ApertivoWeb.HappyHourLive.Index do
  use ApertivoWeb, :live_view

  alias Apertivo.HappyHours
  alias Apertivo.HappyHours.HappyHour

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :happy_hours, list_happy_hours())}
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

  defp list_happy_hours do
    HappyHours.list_happy_hours()
  end
end
