defmodule Deku.PlayerPositionUpdate do
  @enforce_keys [:entity_id, :position]
  defstruct [:entity_id, :position]
end
