defmodule ExCoverallsLinter.Rules.Errors.MissedFileTest do
  use ExUnit.Case

  alias ExCoverallsLinter.Rules.MissedFile
  alias ExCoverallsLinter.Rules.Errors.RuleError
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines
  alias ExCoverallsLinter.Rules.Errors.CoverageError

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

    assert {:error, error} = MissedFile.check(source_file, required_coverage: 0.8)

    assert %RuleError{reasons: [%CoverageError{}]} = error
    assert error |> to_string() |> is_binary()
  end
end
