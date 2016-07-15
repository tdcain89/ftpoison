defmodule FTPoison.Error do
  defexception reason: nil
  @type t :: %__MODULE__{reason: any}

  def message(%__MODULE__{reason: reason}), do: reason
end
