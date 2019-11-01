defmodule ExCoverallsLinter.CoverageRatio do
  @type t :: float

  def format(coverage), do: Float.round(coverage, 2)
end
