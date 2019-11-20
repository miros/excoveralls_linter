defmodule ExCoverallsLinter.CoverageTool do
  alias ExCoverallsLinter.SourceFile

  @type t :: module

  @callback get_coverage() :: list(SourceFile.t())
end
