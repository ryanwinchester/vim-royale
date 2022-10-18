defmodule Deku do
  @moduledoc """
  Decode deez nuts.
  """

  import Deku.BinaryTypes

  # Message IDs
  @whoami 0
  @player_start 1
  @player_position_update 2
  @create_entity 3
  @delete_entity 4
  @health_update 5
  @circle_position 6
  @circle_start 7
  @player_count 8
  @player_queue_count 9
  @game_count 10
  @player_queue_count_result 11
  @game_count_result 12

  # WhoAmI
  @whoami_server 0
  @whoami_client 1

  @doc """
  Decode game packets.

  ## Examples

      iex> Deku.decode(<<1::16, 1::8, 0::8, 1::8>>)
      %Deku.ServerMessage{
        seq_nu: 1,
        version: 1,
        msg: %Deku.Whoami{
          type: :client
        }
      }

      iex> Deku.decode(<<2::16, 1::8, 1::8, 420::24, 69::16, 10::32>>)
      %Deku.ServerMessage{
        seq_nu: 2,
        version: 1,
        msg: %Deku.PlayerStart{
          entity_id: 420,
          range: 69,
          position: 10
        }
      }

  """
  @spec decode(binary) :: Deku.ServerMessage.t
  def decode(<<seq::uint(16), ver::uint(8), msg::binary>>) do
    %Deku.ServerMessage{
      seq_nu: seq,
      version: ver,
      msg: decode_message(msg)
    }
  end

  @doc """
  Decode messages.
  """
  @spec decode_message(binary) :: struct
  def decode_message(<<@whoami::uint(8), @whoami_server::uint(8)>>) do
    %Deku.Whoami{type: :server}
  end

  def decode_message(<<@whoami::uint(8), @whoami_client::uint(8)>>) do
    %Deku.Whoami{type: :client}
  end

  def decode_message(<<@player_start::uint(8), id::uint(24), rng::uint(16), pos::uint(32)>>) do
    %Deku.PlayerStart{entity_id: id, range: rng, position: pos}
  end

  def decode_message(<<@player_start::uint(8), id::uint(24), pos::uint(32)>>) do
    %Deku.PlayerPositionUpdate{entity_id: id, position: pos}
  end

  def decode_message(<<@create_entity::uint(8), id::uint(24), pos::uint(32), inf::uint(8)>>) do
    %Deku.CreateEntity{entity_id: id, position: pos, info: inf}
  end

  def decode_message(<<@delete_entity::uint(8), id::uint(24)>>) do
    %Deku.DeleteEntity{entity_id: id}
  end

  def decode_message(<<type::uint(8), _rest::binary>>) do
    raise "TODO: Implement decoding for type #{type}"
  end
end
