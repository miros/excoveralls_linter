defmodule ExCoverallsLinter.CoverageTools.Excoveralls.OutputParser do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines

  # TODO test this

  @spec parse(String.t()) :: list(SourceFile.t())
  def parse(data) do
    data
    |> Jason.decode!()
    |> Map.fetch!("source_files")
    |> Enum.map(&to_source_file/1)
  end

  defp to_source_file(attrs) do
    coverage_lines = Map.fetch!(attrs, "coverage")
    source_lines = attrs |> Map.fetch!("source") |> String.split("\n")

    %SourceFile{
      name: attrs["name"],
      lines: to_lines(coverage_lines, source_lines)
    }
  end

  defp to_lines(coverage_lines, source_lines) do
    coverage_lines
    |> Enum.zip(source_lines)
    |> Enum.with_index()
    |> Enum.map(fn
      {{nil = _times_covered, source}, index} ->
        %Lines.Irrelevant{number: index, source: source}

      {{times_covered, source}, index} ->
        %Lines.Relevant{number: index, source: source, times_covered: times_covered}
    end)
  end
end
