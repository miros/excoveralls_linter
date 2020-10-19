defmodule ExCoverallsLinter.Rules.MissedFile do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Rules.Errors.FileRuleError
  alias ExCoverallsLinter.Rules.Errors.CoverageError
  alias ExCoverallsLinter.CoverageRatio

  @behaviour ExCoverallsLinter.CoverageRule

  @type option :: {:required_coverage, CoverageRatio.t()}

  @impl true
  def check(files, options) do
    required_coverage = Keyword.fetch!(options, :required_coverage)
    files |> Enum.map(&check_file(&1, required_coverage)) |> Enum.reject(&is_nil/1)
  end

  defp check_file(file, required_coverage) do
    actual_coverage = SourceFile.coverage_ratio(file)

    if actual_coverage >= required_coverage do
      nil
    else
      FileRuleError.new(file, %CoverageError{
        actual_coverage: actual_coverage,
        required_coverage: required_coverage
      })
    end
  end
end
