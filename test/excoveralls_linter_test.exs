defmodule ExCoverallsLinterTest do
  use ExUnit.Case

  alias ExCoverallsLinter.CoverageRule
  alias ExCoverallsLinter.Rules.Errors.RuleError
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines
  alias ExCoverallsLinter.CoverageTool

  defmodule FakeCoverageTool do
    @behaviour CoverageTool

    def get_coverage do
      [%SourceFile{name: "some-file", lines: [%Lines.Relevant{}]}]
    end
  end

  defmodule RuleWithOK do
    @behaviour CoverageRule

    def check(%SourceFile{name: "some-file"}, _options) do
      :ok
    end
  end

  defmodule RuleWithError do
    @behaviour CoverageRule

    def check(source_file = %SourceFile{name: "some-file"}, _options) do
      {:error, %RuleError{file: source_file, reasons: []}}
    end
  end

  test "returns ok when all rules are fulfilled" do
    rule_specs = [{RuleWithOK, []}]
    assert :ok == ExCoverallsLinter.run(rule_specs, FakeCoverageTool)
  end

  test "returns error when some rules fail" do
    rule_specs = [{RuleWithError, []}]

    assert {:error, [%RuleError{file: %SourceFile{name: "some-file"}}]} =
             ExCoverallsLinter.run(rule_specs, FakeCoverageTool)
  end

  defmodule CoverageToolWithIrrelevantFile do
    @behaviour CoverageTool

    def get_coverage do
      [
        %SourceFile{name: "irrelevant-file", lines: [%Lines.Irrelevant{}]}
      ]
    end
  end

  test "skips all files with no relevant lines" do
    rule_specs = [{RuleWithError, []}]
    assert :ok == ExCoverallsLinter.run(rule_specs, CoverageToolWithIrrelevantFile)
  end
end
