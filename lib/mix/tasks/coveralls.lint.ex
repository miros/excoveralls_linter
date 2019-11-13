defmodule Mix.Tasks.Coveralls.Lint do
  use Mix.Task

  @shortdoc "Runs excoveralls and checks coverage"
  @preferred_cli_env :test

  # TODO write integration test

  @impl Mix.Task
  def run(args, exit_function \\ &exit/1) do
    case do_run(args) do
      :ok ->
        Mix.Shell.IO.info("OK")

      {:error, errors} ->
        print_errors(errors)
        exit_function.({:shutdown, 1})
    end
  end

  defp do_run(args) do
    args
    |> parse_args()
    |> rule_specs()
    |> ExCoverallsLinter.run()
  end

  defp parse_args(args) do
    cli_description() |> Optimus.parse!(args)
  end

  defp rule_specs(%{options: options}) do
    [
      {ExCoverallsLinter.Rules.MissedFile,
       [required_coverage: options["required_file_coverage"]]},
      {ExCoverallsLinter.Rules.MissedCodeBlock, [max_missed_lines: options["max_missed_lines"]]}
    ]
  end

  defp print_errors(errors) do
    for error <- errors do
      Mix.Shell.IO.error(to_string(error))
    end
  end

  defp cli_description do
    Optimus.new!(
      name: "coveralls.lint",
      allow_unknown_args: false,
      parse_double_dash: true,
      options: [
        date_from: [
          value_name: "MAX_MISSED_LINES",
          long: "--max-missed-lines",
          help: "Report files with more than MAX_MISSED_LINES uncovered lines in a row",
          parser: :integer,
          required: true
        ],
        date_to: [
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
