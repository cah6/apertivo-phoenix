defmodule ApertivoWeb.HappyHourLive.FormComponent do
  use ApertivoWeb, :live_component

  alias Apertivo.HappyHours

  @impl true
  def update(%{happy_hour: happy_hour} = assigns, socket) do
    changeset = HappyHours.change_happy_hour(happy_hour)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"happy_hour" => happy_hour_params}, socket) do
    changeset =
      socket.assigns.happy_hour
      |> HappyHours.change_happy_hour(happy_hour_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"happy_hour" => happy_hour_params}, socket) do
    save_happy_hour(socket, socket.assigns.action, happy_hour_params)
  end

  defp save_happy_hour(socket, :edit, happy_hour_params) do
    case HappyHours.update_happy_hour(socket.assigns.happy_hour, happy_hour_params) do
      {:ok, _happy_hour} ->
        {:noreply,
         socket
         |> put_flash(:info, "Happy hour updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_happy_hour(socket, :new, happy_hour_params) do
    case HappyHours.create_happy_hour(happy_hour_params) do
      {:ok, _happy_hour} ->
        {:noreply,
         socket
         |> put_flash(:info, "Happy hour created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
