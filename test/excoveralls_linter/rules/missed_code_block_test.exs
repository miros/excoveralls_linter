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
        %Lines.Relevant{number: 0, times_covered: 1},
        %Lines.Relevant{number: 1, times_covered: 0},
        %Lines.Relevant{number: 2, times_covered: 0},
        %Lines.Relevant{number: 3, times_covered: 0},
        %Lines.Relevant{number: 4, times_covered: 1},
        %Lines.Relevant{number: 5, times_covered: 1},
        %Lines.Relevant{number: 6, times_covered: 0},
        %Lines.Relevant{number: 7, times_covered: 0},
        %Lines.Relevant{number: 8, times_covered: 1},
        %Lines.Relevant{number: 9, times_covered: 0},
        %Lines.Relevant{number: 10, times_covered: 1}
      ]
    }

    assert :ok == MissedCodeBlock.check(source_file, max_missed_lines: 10)

    assert {:error,
            %RuleError{
              errors: [
                %CodeBlockError{
                  lines: [
                    %Lines.Relevant{number: 1},
                    %Lines.Relevant{number: 2},
                    %Lines.Relevant{number: 3}
                  ]
                },
                %CodeBlockError{
                  lines: [
                    %Lines.Relevant{number: 6},
                    %Lines.Relevant{number: 7}
                  ]
                }
              ]
            }} = MissedCodeBlock.check(source_file, max_missed_lines: 2)
  end
end
