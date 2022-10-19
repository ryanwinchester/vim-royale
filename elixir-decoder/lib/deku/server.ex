defmodule Deku.Server do
  use GenServer

  import Deku.BinaryTypes

  require Logger

  @port 42000
  @backlog 1000

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  def get_socket do
    GenServer.call(__MODULE__, :get_socket)
  end

  ## GenServer Callbacks

  @impl GenServer
  def init(_) do
    {:ok, socket} = :gen_tcp.listen(@port, [:binary, packet: 0, active: true, backlog: @backlog])
    {:ok, socket, {:continue, :accept}}
  end

  @impl GenServer
  def handle_continue(:accept, socket) do
    send(self(), :accept)
    {:noreply, {<<>>, 0, socket}}
  end

  @impl GenServer
  def handle_info(:accept, {_data, _offset, socket} = state) do
    Logger.info("[Server] starting TCP server on port #{@port}...")
    {:ok, _socket} = :gen_tcp.accept(socket)
    {:noreply, state}
  end

  # The beginning of a new game packet.
  def handle_info({:tcp, _client, <<message_size::uint(8), data::binary>>}, {<<>>, 0, socket}) do
    {remainder, size, messages} = parse(data, message_size)
    Logger.debug("[Server] Parsed messages: #{inspect(messages)}")
    {:noreply, {remainder, size, socket}}
  end

  # Game packet with remaining data from last message.
  def handle_info({:tcp, _client, data}, {msg_part, message_size, socket}) do
    {remainder, size, messages} = parse(msg_part <> data, message_size)
    Logger.debug("[Server] Parsed messages: #{inspect(messages)}")
    {:noreply, {remainder, size, socket}}
  end

  def handle_info({:tcp_closed, _}, state), do: {:stop, :normal, state}
  def handle_info({:tcp_error, _}, state), do: {:stop, :normal, state}

  ## Helpers

  defp parse(data, size, messages \\ [])

  defp parse(data, size, messages) when size > byte_size(data) do
    {data, size, messages}
  end

  defp parse(data, size, messages) do
    case data do
      <<message::bytes(size), next::uint(8), rest::binary>> ->
        parse(rest, next, [Deku.decode(message) | messages])

      <<message::bytes(size)>> ->
        {<<>>, 0, [Deku.decode(message) | messages]}

      remainder ->
        {remainder, size, messages}
    end
  end
end
