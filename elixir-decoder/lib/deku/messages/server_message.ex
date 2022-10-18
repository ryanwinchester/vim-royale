defmodule Deku.ServerMessage do
  @moduledoc """
  Server message struct.
  """

  @type t :: %__MODULE__{
    seq_nu: non_neg_integer(),
    version: non_neg_integer(),
    msg: struct()
  }

  @enforce_keys [:seq_nu, :version, :msg]
  defstruct [:seq_nu, :version, :msg]
end
