defmodule ExCoverallsLinter.Rules.MissedCodeBlock do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Rules.Errors.FileRuleError
  alias ExCoverallsLinter.Rules.Errors.CodeBlockError

  @behaviour ExCoverallsLinter.CoverageRule

  @type option :: {:missed_lines_threshold, pos_integer}

  @impl true
  def check(files, options) do
    missed_lines_threshold = Keyword.fetch!(options, :missed_lines_threshold)
    files |> Enum.map(&check_file(&1, missed_lines_threshold)) |> Enum.reject(&is_nil/1)
  end

  defp check_file(file, missed_lines_threshold) do
    errors =
      file
      |> SourceFile.uncovered_line_blocks()
      |> Enum.map(&check_block(&1, missed_lines_threshold))
      |> Enum.reject(&is_nil/1)

    case errors do
      [] -> nil
      [_ | _] -> FileRuleError.new(file, errors)
    end
  end

  defp check_block(code_block, missed_lines_threshold)
       when length(code_block) < missed_lines_threshold,
       do: nil

  defp check_block(code_block, missed_lines_threshold) do
    %CodeBlockError{code_block: code_block, missed_lines_threshold: missed_lines_threshold}
  end
end
