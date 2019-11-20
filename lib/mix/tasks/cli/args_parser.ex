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
        max_missed_lines: [
          value_name: "MAX_MISSED_LINES",
          long: "--max-missed-lines",
          help: "Report files with more than MAX_MISSED_LINES uncovered lines in a row",
          parser: :integer,
          required: true
        ],
        required_file_coverage: [
          value_name: "REQUIRED_FILE_COVERAGE",
          long: "--required-file-coverage",
          help: "Report files with less than REQUIRED_FILE_COVERAGE",
          parser: :float,
          required: true
        ]
      ]
    )
  end
end
