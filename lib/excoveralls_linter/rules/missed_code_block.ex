defmodule ExCoverallsLinter.Rules.MissedCodeBlock do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Rules.Errors.RuleError
  alias ExCoverallsLinter.Rules.Errors.CodeBlockError

  @behaviour ExCoverallsLinter.CoverageRule

  @type option :: {:max_missed_lines, pos_integer}

  @impl true
  def check(file, options) do
    max_missed_lines = Keyword.fetch!(options, :max_missed_lines)

    errors =
      file
      |> SourceFile.uncovered_line_blocks()
      |> Enum.map(&check_block(&1, max_missed_lines))
      |> Enum.reject(&is_nil/1)

    case errors do
      [] -> :ok
      [_ | _] -> {:error, RuleError.new(file, errors)}
    end
  end

  defp check_block(code_block, max_missed_lines) when length(code_block) < max_missed_lines,
    do: nil

  defp check_block(code_block, max_missed_lines) do
    %CodeBlockError{code_block: code_block, max_missed_lines: max_missed_lines}
  end
end
