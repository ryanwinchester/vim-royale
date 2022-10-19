defmodule Deku.HealthUpdate do
  @enforce_keys [:entity_id, :health]
  defstruct [:entity_id, :health]
end
