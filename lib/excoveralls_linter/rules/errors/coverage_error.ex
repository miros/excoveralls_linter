defmodule ExCoverallsLinter.Rules.Errors.CoverageError do
  alias ExCoverallsLinter.CoverageRatio
  alias __MODULE__

  defexception [:actual_coverage, :required_coverage]

  @type t :: %__MODULE__{
          actual_coverage: CoverageRatio.t(),
          required_coverage: CoverageRatio.t()
        }

  @impl Exception
  def message(exc) do
    actual = CoverageRatio.format(exc.actual_coverage)
    required = CoverageRatio.format(exc.required_coverage)

    "low coverage:#{actual} (< required:#{required})"
  end

  defimpl String.Chars do
    def to_string(exc), do: CoverageError.message(exc)
  end
end
