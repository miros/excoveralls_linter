defmodule ExCoverallsLinter.CoverageRatio do
  @type t :: float

  def round(coverage) when is_integer(coverage), do: coverage
  def round(coverage) when is_float(coverage), do: Float.round(coverage, 3)
end
