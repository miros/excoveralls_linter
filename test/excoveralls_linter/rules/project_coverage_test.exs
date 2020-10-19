defmodule ExCoverallsLinter.Rules.ProjectCoverageTest do
  use ExUnit.Case

  alias ExCoverallsLinter.Rules.ProjectCoverage
  alias ExCoverallsLinter.Rules.Errors.ProjectRuleError
  alias ExCoverallsLinter.Rules.Errors.CoverageError
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines

  describe "#total_coverage" do
    test "returns total coverage percentage of all files" do
      files = [
        %SourceFile{
          name: "some-file",
          lines: [%Lines.Relevant{times_covered: 0}, %Lines.Relevant{times_covered: 1}]
        },
        %SourceFile{
          name: "other-file",
          lines: [%Lines.Relevant{times_covered: 0}, %Lines.Relevant{times_covered: 1}]
        }
      ]

      assert ProjectCoverage.check(files, required_project_coverage: 0.4) == []

      assert [%ProjectRuleError{reasons: [%CoverageError{}]}] =
               ProjectCoverage.check(files, required_project_coverage: 0.6)
    end
  end
end
