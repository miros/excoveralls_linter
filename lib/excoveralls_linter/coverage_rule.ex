defmodule ExCoverallsLinter.CoverageRule do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Rules.Errors.RuleError

  @type t :: module

  @callback check(SourceFile.t(), keyword) :: :ok | {:error, RuleError.t()}
end
