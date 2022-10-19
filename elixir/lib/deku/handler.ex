defmodule Deku.Handler do
  @moduledoc """
  The handler module that handles the server's data for each connection.
  """
  use ThousandIsland.Handler

  import Deku.BinaryTypes

  require Logger

  @impl ThousandIsland.Handler
  def handle_connection(_socket, _state) do
    # The initial state for this connection is a tuple of:
    #   `{remaining_bytes, message_byte_size, messages_parsed, start_time}`.
    {:continue, {<<>>, 0, 0, :os.system_time(:millisecond)}}
  end

  # The beginning of a the data.
  @impl ThousandIsland.Handler
  def handle_data(<<message_size::uint(8), data::binary>>, _socket, {<<>>, 0, count, time}) do
    {remainder, size, new_count, _messages} = parse(data, message_size)
    {:continue, {remainder, size, count + new_count, time}}
  end

  # The remaining data.
  @impl ThousandIsland.Handler
  def handle_data(data, _socket, {msg_part, message_size, count, time}) do
    {remainder, size, new_count, _messages} = parse(msg_part <> data, message_size)
    {:continue, {remainder, size, count + new_count, time}}
  end

  @impl ThousandIsland.Handler
  def handle_close(_socket, {_msg_part, _message_size, count, started_at}) do
    diff = :os.system_time(:millisecond) - started_at
    parsed_per_ms = if diff == 0, do: count, else: round(count / diff)
    Logger.debug("[Handler] time #{diff}, count: #{count}, parsed per ms: #{parsed_per_ms}")
  end

  ## Helpers

  defp parse(data, size, count \\ 0, messages \\ [])

  defp parse(data, size, count, messages) when size > byte_size(data) do
    {data, size, count, messages}
  end

  defp parse(data, size, count, messages) do
    case data do
      <<message::bytes(size), next::uint(8), rest::binary>> ->
        parse(rest, next, count + 1, [Deku.decode(message) | messages])

      <<message::bytes(size)>> ->
        {<<>>, 0, count + 1, [Deku.decode(message) | messages]}

      remainder ->
        {remainder, size, count, messages}
    end
  end
end
