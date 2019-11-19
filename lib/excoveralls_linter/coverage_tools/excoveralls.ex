defmodule ExCoverallsLinter.CoverageTools.Excoveralls do
  alias ExCoverallsLinter.CoverageTool
  alias ExCoverallsLinter.CoverageTools.Excoveralls.OutputParser

  @behaviour CoverageTool

  @impl CoverageTool
  def get_coverage() do
    umbrella_opts =
      if Mix.Project.umbrella?() do
        ["--umbrella"]
      else
        []
      end

    Mix.Task.run("coveralls.json", ["--output-dir", "./cover"] ++ umbrella_opts)

    File.read!("./cover/excoveralls.json")
    |> OutputParser.parse()
  end
end
