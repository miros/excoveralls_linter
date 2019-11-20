defmodule Mix.Tasks.Coveralls.Lint.CLI.ArgsParserTest do
  use ExUnit.Case

  alias Mix.Tasks.Coveralls.Lint.CLI.ArgsParser

  test "it correctly parses required args" do
    assert %{max_missed_lines: 123, required_file_coverage: 0.9} =
             ArgsParser.parse(["--max-missed-lines=123", "--required-file-coverage=0.9"])
  end
end
