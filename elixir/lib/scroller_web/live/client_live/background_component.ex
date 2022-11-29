defmodule ScrollerWeb.ClientLive.BackgroundComponent do
  use ScrollerWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <img class="animu" alt="animu" src="https://raw.githubusercontent.com/ThePrimeagen/anime/master/oskr_the_primeagen_6371be34-bd8a-4643-82c1-d480ec36ea29.png"/>
      <div class="background center">
      </div>
    </div>
    """
  end
end
