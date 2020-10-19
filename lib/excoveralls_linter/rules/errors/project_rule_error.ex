defmodule ExCoverallsLinter.Rules.Errors.ProjectRuleError do
  alias __MODULE__

  defexception [:reasons]

  @type t :: %__MODULE__{
          reasons: list()
        }

  @impl Exception
  def message(exc) do
    "Project error: " <> Enum.join(exc.reasons, ", ")
  end

  @spec new(term | list()) :: t
  def new(reasons) do
    %__MODULE__{reasons: List.wrap(reasons)}
  end

  defimpl String.Chars do
    def to_string(exc), do: ProjectRuleError.message(exc)
  end
end
