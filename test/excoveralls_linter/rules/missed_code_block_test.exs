defmodule ExCoverallsLinter.Rules.MissedCodeBlockTest do
  use ExUnit.Case

  alias ExCoverallsLinter.Rules.MissedCodeBlock
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines
  alias ExCoverallsLinter.Rules.Errors.RuleError
  alias ExCoverallsLinter.Rules.Errors.CodeBlockError

  test "returns error when file has uncovered code blocks longer than threshold" do
    source_file = %SourceFile{
      lines: [
        %Lines.Relevant{number: 1, times_covered: 1},
        %Lines.Relevant{number: 2, times_covered: 0},
        %Lines.Relevant{number: 3, times_covered: 0},
        %Lines.Relevant{number: 4, times_covered: 0},
        %Lines.Relevant{number: 5, times_covered: 1},
        %Lines.Relevant{number: 6, times_covered: 1},
        %Lines.Relevant{number: 7, times_covered: 0},
        %Lines.Relevant{number: 8, times_covered: 0},
        %Lines.Relevant{number: 9, times_covered: 1},
        %Lines.Relevant{number: 10, times_covered: 0},
        %Lines.Relevant{number: 11, times_covered: 1}
      ]
    }

    assert :ok == MissedCodeBlock.check(source_file, missed_lines_threshold: 10)

    assert {:error, error} = MissedCodeBlock.check(source_file, missed_lines_threshold: 2)

    assert %RuleError{
             reasons: [
               %CodeBlockError{
                 code_block: [
                   %Lines.Relevant{number: 2},
                   %Lines.Relevant{number: 3},
                   %Lines.Relevant{number: 4}
                 ]
               },
               %CodeBlockError{
                 code_block: [
                   %Lines.Relevant{number: 7},
                   %Lines.Relevant{number: 8}
                 ]
               }
             ]
           } = error

    assert error |> to_string() |> is_binary()
  end
end
