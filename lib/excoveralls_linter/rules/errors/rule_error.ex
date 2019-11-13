defmodule ExCoverallsLinter.Rules.Errors.RuleError do
  alias ExCoverallsLinter.SourceFile
  alias __MODULE__

  defexception [:file, :reasons]

  @type t :: %__MODULE__{
          file: SourceFile.t(),
          reasons: list()
        }

  @impl Exception
  def message(exc) do
    "file:#{exc.file} breaks coverage rules reasons:#{Enum.join(exc.reasons, ", ")}"
  end

  @spec new(SourceFile.t(), term | list()) :: t
  def new(file, reasons) do
    %__MODULE__{file: file, reasons: List.wrap(reasons)}
  end

  defimpl String.Chars do
    def to_string(exc), do: RuleError.message(exc)
  end
end
