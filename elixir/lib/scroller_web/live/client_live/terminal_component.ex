defmodule ScrollerWeb.ClientLive.TerminalComponent do
  use ScrollerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="terminal">
      <.terminal_relative_nu />
      <.terminal_display rows={@rows} />
    </div>
    """
  end

  defp terminal_relative_nu(assigns) do
    ~H"""
    <div class="terminal-relative-nu">
      <%= for _ <- 0..23 do %>
        <div class="terminal-column">
          <%= for _ <- 0..2 do %>
            <div class="terminal-byte"></div>
          <% end %>
        </div>
      <% end %>
    </div>
    """
  end

  defp terminal_display(assigns) do
    ~H"""
    <div class="terminal-display">
      <%= for row <- @rows, char <- row do %>
        <div class={"terminal-byte #{get_str(char)}"}></div>
      <% end %>
    </div>
    """
  end

  # Converts a char to a string.
  # '0' == [48]; '1' == [49]; etc.
  defp get_str(48), do: "off"
  defp get_str(49), do: "partial"
  defp get_str(_), do: "on"
end
