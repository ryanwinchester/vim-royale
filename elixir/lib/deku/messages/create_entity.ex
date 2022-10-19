defmodule Deku.CreateEntity do
  @enforce_keys [:entity_id, :position, :info]
  defstruct [:entity_id, :position, :info]
end
