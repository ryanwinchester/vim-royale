defmodule ScrollerWeb.ClientLive.Index do
  use ScrollerWeb, :live_view

  alias ScrollerWeb.ClientLive.TerminalComponent

  @impl true
  def mount(_params, _session, socket) do
    scroll = Enum.map(Scroller.text(), &Stream.cycle(&1))

    {:ok,
     socket
     |> assign(:scroll, scroll)
     |> assign(:rows, next_slice(scroll, 0))
     |> assign(:column, 0)}
  end

  @impl true
  def handle_params(params, _session, socket) do
    params
    |> Map.get("tick", "50")
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

  @impl true
  def render(assigns) do
    ~H"""
    <div class="tokyonight">
      <div>
        <.background />
      </div>

      <div class="center">
        <.status />
      </div>

      <div class="center">
        <.live_component module={TerminalComponent} id="terminal" rows={@rows} />
      </div>
    </div>
    """
  end

  # Background component.
  defp background(assigns) do
    ~H"""
    <div>
      <img
        class="animu"
        alt="animu"
        src="https://raw.githubusercontent.com/ThePrimeagen/anime/master/oskr_the_primeagen_6371be34-bd8a-4643-82c1-d480ec36ea29.png"
      />
      <div class="background center"></div>
    </div>
    """
  end

  # Status component.
  defp status(assigns) do
    ~H"""
    <div class="status">
      {"NOT HERE"}
    </div>
    """
  end
end
