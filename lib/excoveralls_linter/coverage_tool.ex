defmodule ExCoverallsLinter.CoverageTool do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines

  # TODO extract json parsing and unit test this

  @spec get_coverage() :: list(SourceFile.t())
  def get_coverage do
    Mix.Task.run("coveralls.json", ["--umbrella", "--output-dir", "./cover"])

    File.read!("./cover/excoveralls.json")
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
