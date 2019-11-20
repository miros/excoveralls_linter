defmodule ExCoverallsLinter.CoverageTools.Excoveralls.OutputParserTest do
  use ExUnit.Case

  alias ExCoverallsLinter.CoverageTools.Excoveralls.OutputParser
  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines

  test "it parses json output of excoveralls" do
    json = """
      {"source_files": [
        {"coverage": [null, 100, 0], "source": "line0\\nline1\\nline2", "name": "some-file"},
        {"coverage": [], "source": "", "name": "other-file"}
      ]}
    """

    assert [
             %SourceFile{
               name: "some-file",
               lines: [
                 %Lines.Irrelevant{number: 1, source: "line0"},
                 %Lines.Relevant{number: 2, times_covered: 100, source: "line1"},
                 %Lines.Relevant{number: 3, times_covered: 0, source: "line2"}
               ]
             },
             %SourceFile{name: "other-file", lines: []}
           ] = OutputParser.parse(json)
  end
end
