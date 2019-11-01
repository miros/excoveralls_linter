defmodule ExCoverallsLinter.Lines.Irrelevant do
  defstruct [:number, :source]

  @type t :: %__MODULE__{
          number: non_neg_integer,
          source: String.t()
        }
end
