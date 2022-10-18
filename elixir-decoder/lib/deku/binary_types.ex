defmodule Deku.BinaryTypes do
  @moduledoc """
  Macros to make binary pattern-matching less verbose.
  """

  defmacro bits(n), do: quote(do: bitstring-size(unquote(n)))
  defmacro bytes(n), do: quote(do: binary-size(unquote(n)))
  defmacro uint(n), do: quote(do: unsigned-integer-size(unquote(n)))
  defmacro biguint(n), do: quote(do: big-unsigned-integer-size(unquote(n)))
end
