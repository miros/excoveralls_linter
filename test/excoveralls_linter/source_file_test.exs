defmodule ExCoverallsLinter.SourceFileTest do
  use ExUnit.Case

  alias ExCoverallsLinter.SourceFile
  alias ExCoverallsLinter.Lines

  describe "relevant_lines" do
    test "returns only relevant lines" do
      lines = [
        %Lines.Relevant{number: 0},
        %Lines.Irrelevant{number: 1},
        %Lines.Relevant{number: 2},
        %Lines.Irrelevant{number: 3},
        %Lines.Relevant{number: 4}
      ]

      assert [
               %Lines.Relevant{number: 0},
               %Lines.Relevant{number: 2},
               %Lines.Relevant{number: 4}
             ] = source_file_with(lines) |> SourceFile.relevant_lines()
    end
  end

  describe "covered_lines" do
    test "returns only covered relevant lines" do
      lines = [
        %Lines.Relevant{number: 0, times_covered: 0},
        %Lines.Irrelevant{number: 1},
        %Lines.Relevant{number: 2, times_covered: 1},
        %Lines.Relevant{number: 3, times_covered: 10}
      ]

      assert [
               %Lines.Relevant{number: 2},
               %Lines.Relevant{number: 3}
             ] = source_file_with(lines) |> SourceFile.covered_lines()
    end
  end

  describe "coverage_ratio" do
    test "computes coverage ratio of file" do
      lines = [
        %Lines.Relevant{number: 0, times_covered: 0},
        %Lines.Irrelevant{number: 1},
        %Lines.Relevant{number: 2, times_covered: 1},
        %Lines.Relevant{number: 3, times_covered: 10}
      ]

      assert_in_delta 0.66, source_file_with(lines) |> SourceFile.coverage_ratio(), 0.01
    end
  end

  describe "relevant?" do
    test "returns true if file has at least some relevant lines" do
      lines = [
        %Lines.Irrelevant{number: 1},
        %Lines.Irrelevant{number: 1},
        %Lines.Relevant{number: 2},
        %Lines.Irrelevant{number: 3}
      ]

      assert source_file_with(lines) |> SourceFile.relevant?()
    end

    test "returns false if file has no relevant lines at all" do
      lines = [
        %Lines.Irrelevant{number: 1},
        %Lines.Irrelevant{number: 1},
        %Lines.Irrelevant{number: 2},
        %Lines.Irrelevant{number: 3}
      ]

      refute source_file_with(lines) |> SourceFile.relevant?()
    end
  end

  describe "uncovered_line_blocks" do
    test "returns blocks of uncovered consecutive lines" do
      lines = [
        %Lines.Relevant{number: 0, times_covered: 1},
        %Lines.Relevant{number: 1, times_covered: 0},
        %Lines.Relevant{number: 2, times_covered: 0},
        %Lines.Relevant{number: 3, times_covered: 1},
        %Lines.Relevant{number: 4, times_covered: 0},
        %Lines.Relevant{number: 5, times_covered: 1}
      ]

      assert [
               [%Lines.Relevant{number: 1}, %Lines.Relevant{number: 2}],
               [%Lines.Relevant{number: 4}]
             ] = source_file_with(lines) |> SourceFile.uncovered_line_blocks()
    end

    test "ignores irrelevant lines" do
      lines = [
        %Lines.Relevant{number: 0, times_covered: 0},
        %Lines.Irrelevant{number: 1},
        %Lines.Relevant{number: 2, times_covered: 0}
      ]

      assert [
               [%Lines.Relevant{number: 0}],
               [%Lines.Relevant{number: 2}]
             ] = source_file_with(lines) |> SourceFile.uncovered_line_blocks()
    end
  end

  def source_file_with(lines), do: %SourceFile{name: "some-file", lines: lines}
end
