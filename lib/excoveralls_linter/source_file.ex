defmodule ExCoverallsLinter.SourceFile do
  defstruct [:name, :lines]

  alias ExCoverallsLinter.Lines
  alias ExCoverallsLinter.Line
  alias ExCoverallsLinter.CoverageRatio
  alias ExCoverallsLinter.CodeBlock

  @type t :: %__MODULE__{
          name: String.t(),
          lines: list(Line.t())
        }

  @spec relevant?(t) :: boolean
  def relevant?(%__MODULE__{} = file) do
    file |> relevant_lines() |> Enum.count() > 0
  end

  @spec uncovered_line_blocks(t) :: list(CodeBlock.t())
  def uncovered_line_blocks(%__MODULE__{} = file) do
    file
    |> relevant_lines()
    |> Enum.chunk_by(&Line.covered?/1)
    |> Enum.reject(&(hd(&1) |> Line.covered?()))
  end

  @spec coverage_ratio(t) :: CoverageRatio.t()
  def coverage_ratio(%__MODULE__{} = file) do
    covered = file |> covered_lines() |> Enum.count()
    total = file |> relevant_lines() |> Enum.count()

    covered / total
  end

  @spec relevant_lines(t) :: [Lines.Relevant.t()]
  def relevant_lines(%__MODULE__{lines: lines}) do
    Enum.filter(lines, &match?(%Lines.Relevant{}, &1))
  end

  @spec covered_lines(t) :: [Lines.Relevant.t()]
  def covered_lines(%__MODULE__{} = file) do
    file
    |> relevant_lines()
    |> Enum.filter(&Line.covered?/1)
  end
end
