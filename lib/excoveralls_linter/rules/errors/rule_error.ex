defmodule ExCoverallsLinter.Rules.Errors.RuleError do
  alias ExCoverallsLinter.SourceFile
  alias __MODULE__

  defexception [:file, :errors]

  @type t :: %__MODULE__{
          file: SourceFile.t(),
          errors: list()
        }

  @impl Exception
  def message(exc) do
    "file:#{exc.file} errors:#{Enum.join(exc.errors, ", ")}"
  end

  @spec new(SourceFile.t(), term | list()) :: t
  def new(file, errors) do
    %__MODULE__{file: file, errors: List.wrap(errors)}
  end

  defimpl String.Chars do
    def to_string(exc), do: RuleError.message(exc)
  end
end
