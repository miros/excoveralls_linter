defmodule ExCoverallsLinter.Lines.Relevant do
  defstruct [:number, :source, :times_covered]

  @type t :: %__MODULE__{
          number: non_neg_integer,
          source: String.t(),
          times_covered: non_neg_integer()
        }
end
