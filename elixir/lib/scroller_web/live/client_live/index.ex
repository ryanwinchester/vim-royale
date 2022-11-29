defmodule ScrollerWeb.ClientLive.Index do
  use ScrollerWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <div class="tokyonight">
      <div>
        <.live_component id="background" module={ScrollerWeb.ClientLive.BackgroundComponent} />
      </div>

      <div class="center">
        <.live_component id="status" module={ScrollerWeb.ClientLive.StatusComponent} />
      </div>

      <div class="center">
        <.live_component
          id="terminal"
          module={ScrollerWeb.ClientLive.TerminalComponent}
          rows={@rows}
        />
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    scroll = Enum.map(Scroller.text(), &Stream.cycle(&1))

    {:ok,
      socket
      |> assign(:scroll, scroll)
      |> assign(:rows, Enum.map(scroll, &slice_row(&1, 0)))
      |> assign(:column, 0)}
  end

  @impl true
  def handle_params(params, _session, socket) do
    params
    |> Map.get("tick", "500")
    |> String.to_integer()
    |> :timer.send_interval(self(), :tick)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    column = socket.assigns.column + 1

    {:noreply,
      socket
      |> assign(:rows, next_slice(socket.assigns.scroll, column))
      |> assign(:column, column)}
  end

  defp next_slice(scroll, column), do: Enum.map(scroll, &slice_row(&1, column))
  defp slice_row(row, column), do: Enum.slice(row, column, 80)
end
