defmodule ExCoverallsLinter.CoverageRule do
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Rules.Errors.FileRuleError
  alias ExCoverallsLinter.Rules.Errors.ProjectRuleError

  @type t :: module

  @callback check(list(SourceFile.t()), options :: keyword) ::
              list(FileRuleError.t() | ProjectRuleError.t())
end
