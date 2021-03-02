defmodule ApertivoWeb.ReelItem do
  use ApertivoWeb, :live_component
  # use Phoenix.LiveComponent

  defp borderWidth(selected) do
    if selected do
      "var(--border-thick)"
    else
      "var(--border-thin)"
    end
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
