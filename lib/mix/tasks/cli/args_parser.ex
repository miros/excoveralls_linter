defmodule Mix.Tasks.Coveralls.Lint.CLI.ArgsParser do
  @spec parse(command_line_args :: [binary]) :: Access.container()
  def parse(args) do
    result = cli_description() |> Optimus.parse!(args)
    result.options
  end

  defp cli_description do
    Optimus.new!(
      name: "coveralls.lint",
      allow_unknown_args: false,
      parse_double_dash: true,
      options: [
        missed_lines_threshold: [
          value_name: "MISSED_LINES_THRESHOLD",
          long: "--missed-lines-threshold",
          help: "Report files with MISSED_LINES_THRESHOLD or more missed lines in a row",
          parser: :integer,
          required: true
        ],
        required_file_coverage: [
          value_name: "REQUIRED_FILE_COVERAGE",
          long: "--required-file-coverage",
          help: "Report files with less than REQUIRED_FILE_COVERAGE",
          parser: :float,
          required: true
        ],
        required_project_coverage: [
          value_name: "REQUIRED_PROJECT_COVERAGE",
          long: "--required-project-coverage",
          help: "Total required coverage percentage for all files",
          parser: :float,
          default: 0.0,
          required: false
        ]
      ]
    )
  end
end
