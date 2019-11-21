defmodule ExCoverallsLinter.Line do
  alias ExCoverallsLinter.Lines

  @type t :: Lines.Relevant.t() | Lines.Irrelevant.t()

  @spec covered?(t()) :: boolean
  def covered?(%Lines.Relevant{times_covered: 0}), do: false
  def covered?(%Lines.Relevant{times_covered: times_covered}) when times_covered > 0, do: true
  def covered?(%Lines.Irrelevant{}), do: true

  @spec blank?(t()) :: boolean
  def blank?(%{source: source}), do: source |> to_string() |> String.trim() == ""
end
