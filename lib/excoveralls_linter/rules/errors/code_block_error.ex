defmodule ExCoverallsLinter.Rules.Errors.CodeBlockError do
  alias __MODULE__
  alias ExCoverallsLinter.CodeBlock

  defexception [:code_block, :max_missed_lines]

  @type t :: %__MODULE__{
          code_block: CodeBlock.t(),
          max_missed_lines: pos_integer
        }

  @impl Exception
  def message(exc) do
    first_line_num = List.first(exc.code_block).number
    last_line_num = List.last(exc.code_block).number
    total_lines = length(exc.code_block)

    "uncovered block of code at lines #{first_line_num}:#{last_line_num} (#{total_lines} lines) " <>
      "(max:#{exc.max_missed_lines})"
  end

  defimpl String.Chars do
    def to_string(exc), do: CodeBlockError.message(exc)
  end
end
