defmodule ExCoverallsLinter.Line do
  alias ExCoverallsLinter.Lines

  @type t :: Lines.Relevant.t() | Lines.Irrelevant.t()

  def covered?(%Lines.Relevant{times_covered: 0}), do: false
  def covered?(%Lines.Relevant{times_covered: times_covered}) when times_covered > 0, do: true
  def covered?(%Lines.Irrelevant{}), do: true
end
