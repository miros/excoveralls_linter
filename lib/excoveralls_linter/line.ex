defmodule ExCoverallsLinter.Line do
  alias ExCoverallsLinter.Lines

  @type t :: Lines.Relevant.t() | Lines.Irrelevant.t()

  def covered?(%{times_covered: 0}), do: false
  def covered?(%{times_covered: times_covered}) when times_covered > 0, do: true
end
