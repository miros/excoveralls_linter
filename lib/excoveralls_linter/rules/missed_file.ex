defmodule ExCoverallsLinter.Rules.MissedFile do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Rules.Errors.RuleError
  alias ExCoverallsLinter.Rules.Errors.CoverageError
  alias ExCoverallsLinter.CoverageRatio

  @behaviour ExCoverallsLinter.CoverageRule

  @type option :: {:required_coverage, CoverageRatio.t()}

  @impl true
  def check(file, options) do
    actual_coverage = SourceFile.coverage_ratio(file)
    required_coverage = Keyword.fetch!(options, :required_coverage)

    if actual_coverage >= required_coverage do
      :ok
    else
      {:error,
       RuleError.new(file, %CoverageError{
         actual_coverage: actual_coverage,
         required_coverage: required_coverage
       })}
    end
  end
end
