defmodule ExCoverallsLinter.Rules.ProjectCoverage do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Rules.Errors.ProjectRuleError
  alias ExCoverallsLinter.CoverageRatio
  alias ExCoverallsLinter.Rules.Errors.CoverageError

  @behaviour ExCoverallsLinter.CoverageRule

  @type option :: {:required_project_coverage, CoverageRatio.t()}

  @impl true
  def check(files, options) do
    required_coverage = Keyword.fetch!(options, :required_project_coverage)
    actual_coverage = total_coverage(files)

    if CoverageRatio.round(actual_coverage) < CoverageRatio.round(required_coverage) do
      [
        ProjectRuleError.new(%CoverageError{
          actual_coverage: actual_coverage,
          required_coverage: required_coverage
        })
      ]
    else
      []
    end
  end

  @spec total_coverage(list(SourceFile.t())) :: float
  defp total_coverage(source_files) do
    total_lines = source_files |> Enum.map(&SourceFile.relevant_lines_count/1) |> Enum.sum()
    covered_lines = source_files |> Enum.map(&SourceFile.covered_lines_count/1) |> Enum.sum()

    if total_lines > 0 do
      covered_lines / total_lines
    else
      0
    end
  end
end
