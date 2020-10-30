defmodule ExCoverallsLinter.CoverageRatio do
  @type t :: float

  def round(coverage), do: Float.round(coverage, 3)
end
