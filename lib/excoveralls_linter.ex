defmodule ExCoverallsLinter do
  alias ExCoverallsLinter.CoverageTool
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.CoverageRule

  @type rule_spec :: {CoverageRule.t(), options :: keyword}

  @spec run(list(rule_spec)) :: :ok | {:error, errors :: list()}
  def run(rule_specs, coverage_tool \\ CoverageTool) do
    errors =
      coverage_tool.get_coverage()
      |> Enum.filter(&SourceFile.relevant?/1)
      |> Enum.map(&run_rules(&1, rule_specs))
      |> List.flatten()

    case errors do
      [] -> :ok
      [_ | _] -> {:error, errors}
    end
  end

  defp run_rules(%SourceFile{} = _file, []), do: []

  defp run_rules(%SourceFile{} = file, [{rule, options} | other_rules]) do
    errors = file |> rule.check(options) |> rule_errors()
    [errors | run_rules(file, other_rules)]
  end

  defp rule_errors(:ok), do: []
  defp rule_errors({:error, error}), do: [error]
end
