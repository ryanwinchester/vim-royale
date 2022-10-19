defmodule Deku.PlayerStart do
  @enforce_keys [:entity_id, :range, :position]
  defstruct [:entity_id, :range, :position]
end
