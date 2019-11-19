defmodule ExCoverallsLinter.CoverageTool do
  alias ExCoverallsLinter.SourceFile

  @callback get_coverage() :: list(SourceFile.t())
end
