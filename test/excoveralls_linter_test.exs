defmodule ExCoverallsLinterTest do
  use ExUnit.Case

  alias ExCoverallsLinter.CoverageRule
  alias ExCoverallsLinter.Rules.Errors.FileRuleError
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines
  alias ExCoverallsLinter.CoverageTool

  describe "#run" do
    defmodule FakeCoverageTool do
      @behaviour CoverageTool

      def get_coverage do
        [%SourceFile{name: "some-file", lines: [%Lines.Relevant{}]}]
      end
    end

    defmodule RuleWithOK do
      @behaviour CoverageRule

      def check(_files, _options) do
        []
      end
    end

    defmodule RuleWithError do
      @behaviour CoverageRule

      def check([], _options) do
        []
      end

      def check(files, _options) do
        [%FileRuleError{file: List.first(files), reasons: []}]
      end
    end

    test "returns ok when all rules are fulfilled" do
      rule_specs = [{RuleWithOK, []}]
      assert :ok == ExCoverallsLinter.run(rule_specs, FakeCoverageTool)
    end

    test "returns error when some rules fail" do
      rule_specs = [{RuleWithError, []}]

      assert {:error, [%FileRuleError{file: %SourceFile{name: "some-file"}}]} =
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
end
