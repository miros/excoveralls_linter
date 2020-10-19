defmodule ExCoverallsLinter do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.CoverageRule
  alias ExCoverallsLinter.CoverageTool
  alias ExCoverallsLinter.CoverageTools.Excoveralls

  @type rule_spec :: {CoverageRule.t(), options :: keyword}

  @spec run(list(rule_spec), CoverageTool.t()) :: :ok | {:error, errors :: list()}
  def run(rule_specs, coverage_tool \\ Excoveralls) do
    files = coverage_tool.get_coverage() |> Enum.filter(&SourceFile.relevant?/1)

    errors =
      Enum.flat_map(rule_specs, fn {rule, options} ->
        rule.check(files, options)
      end)

    case errors do
      [] -> :ok
      [_ | _] -> {:error, errors}
    end
  end
end
