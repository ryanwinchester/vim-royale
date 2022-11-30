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
    # Users can pass in a `tick` param.
    # Can't go lower than `34` or higher than `2000`.
    # Defaults to `50` for a decently smooth scroll.
    tick_interval =
      params
      |> Map.get("tick", "50")
      |> String.to_integer()
      |> min(2000)
      |> max(34)

    # Send this LiveView a `:tick` message every `tick_interval` ms.
    :timer.send_interval(tick_interval, self(), :tick)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    column = rem(socket.assigns.column, 360)

    {:noreply,
     socket
     |> assign(:rows, next_slice(socket.assigns.scroll, column))
     |> assign(:column, column + 1)}
  end

  # Get the next slice of rows.
  defp next_slice(scroll, column) do
    Enum.map(scroll, &Enum.slice(&1, column, 80))
  end

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
