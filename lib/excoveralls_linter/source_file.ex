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

  @spec total_lines_count(t) :: pos_integer
  def total_lines_count(%__MODULE__{lines: lines}), do: Enum.count(lines)

  @spec relevant_lines_count(t) :: pos_integer
  def relevant_lines_count(%__MODULE__{} = file), do: file |> relevant_lines() |> Enum.count()

  @spec covered_lines_count(t) :: pos_integer
  def covered_lines_count(%__MODULE__{} = file), do: file |> covered_lines() |> Enum.count()

  @spec relevant_lines_count(t) :: pos_integer
  def missed_lines_count(%__MODULE__{} = file),
    do: relevant_lines_count(file) - covered_lines_count(file)

  @spec relevant?(t) :: boolean
  def relevant?(%__MODULE__{} = file) do
    file |> relevant_lines() |> Enum.count() > 0
  end

  @spec uncovered_line_blocks(t) :: list(CodeBlock.t())
  def uncovered_line_blocks(%__MODULE__{} = file) do
    file.lines
    |> Enum.reject(fn
      %Lines.Irrelevant{} = line -> Line.blank?(line)
      _ -> false
    end)
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
