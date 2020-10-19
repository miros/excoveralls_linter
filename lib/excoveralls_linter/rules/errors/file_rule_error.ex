defmodule ExCoverallsLinter.Rules.Errors.FileRuleError do
  alias ExCoverallsLinter.SourceFile
  alias __MODULE__

  defexception [:file, :reasons]

  @type t :: %__MODULE__{
          file: SourceFile.t(),
          reasons: list()
        }

  @impl Exception
  def message(exc) do
    total_lines = SourceFile.total_lines_count(exc.file)
    relevant_line = SourceFile.relevant_lines_count(exc.file)
    missed_lines = SourceFile.missed_lines_count(exc.file)

    "#{exc.file.name} : #{Enum.join(exc.reasons, ", ")} " <>
      "(lines:#{total_lines} relevant:#{relevant_line} missed:#{missed_lines})"
  end

  @spec new(SourceFile.t(), term | list()) :: t
  def new(file, reasons) do
    %__MODULE__{file: file, reasons: List.wrap(reasons)}
  end

  defimpl String.Chars do
    def to_string(exc), do: FileRuleError.message(exc)
  end
end
