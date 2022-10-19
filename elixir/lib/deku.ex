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
  @whoami_wtf 0x45

  @doc """
  Decode game packets.

  ## Examples

      iex> Deku.decode(<<1::16, 1::8, 0::8, 1::8>>)
      %Deku.ServerMessage{
        seq_nu: 1,
        version: 1,
        msg: %Deku.Whoami{
          value: :client
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
  @spec decode(binary) :: Deku.ServerMessage.t()
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

  ## Game Packets

  def decode_message(<<@player_start::uint(8), id::uint(24), rng::uint(16), pos::uint(32)>>) do
    %Deku.PlayerStart{entity_id: id, range: rng, position: pos}
  end

  def decode_message(<<@player_position_update::uint(8), id::uint(24), pos::uint(32)>>) do
    %Deku.PlayerPositionUpdate{entity_id: id, position: pos}
  end

  def decode_message(<<@create_entity::uint(8), id::uint(24), pos::uint(32), inf::uint(8)>>) do
    %Deku.CreateEntity{entity_id: id, position: pos, info: inf}
  end

  def decode_message(<<@delete_entity::uint(8), id::uint(24)>>) do
    %Deku.DeleteEntity{entity_id: id}
  end

  def decode_message(<<@health_update::uint(8), id::uint(24), hlth::uint(16)>>) do
    %Deku.HealthUpdate{entity_id: id, health: hlth}
  end

  def decode_message(<<@circle_position::uint(8), size::uint(16), pos::uint(32), sec::uint(8)>>) do
    %Deku.CirclePosition{size: size, position: pos, seconds: sec}
  end

  def decode_message(<<@circle_start::uint(8), sec::uint(8)>>) do
    %Deku.CircleStart{seconds: sec}
  end

  def decode_message(<<@player_count::uint(8), n::uint(8)>>) do
    %Deku.PlayerCount{value: n}
  end

  ## Server Management

  def decode_message(<<@whoami::uint(8), @whoami_server::uint(8)>>) do
    %Deku.Whoami{value: :server}
  end

  def decode_message(<<@whoami::uint(8), @whoami_client::uint(8)>>) do
    %Deku.Whoami{value: :client}
  end

  def decode_message(<<@whoami::uint(8), @whoami_wtf::uint(8)>>) do
    %Deku.Whoami{value: :wtf_man}
  end

  def decode_message(<<@player_queue_count::uint(8)>>) do
    %Deku.PlayerQueueCount{}
  end

  def decode_message(<<@game_count::uint(8)>>) do
    %Deku.GameCount{}
  end

  def decode_message(<<@player_queue_count_result::uint(8), n::uint(8)>>) do
    %Deku.PlayerQueueCountResult{value: n}
  end

  def decode_message(<<@game_count_result::uint(8), n::uint(16)>>) do
    %Deku.GameCountResult{value: n}
  end
end
