defmodule ExCoverallsLinter.Rules.Errors.RuleErrorTest do
  use ExUnit.Case

  alias ExCoverallsLinter.Rules.MissedFile
  alias ExCoverallsLinter.Rules.Errors.RuleError
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines

  test "returns error when file coverage is below required threshold" do
    source_file = %SourceFile{
      lines: [
        %Lines.Relevant{times_covered: 1},
        %Lines.Relevant{times_covered: 0},
        %Lines.Relevant{times_covered: 0},
        %Lines.Relevant{times_covered: 0}
      ]
    }

    assert :ok == MissedFile.check(source_file, required_coverage: 0.25)
    assert {:error, %RuleError{}} = MissedFile.check(source_file, required_coverage: 0.8)
  end
end
