defmodule Mix.Tasks.Coveralls.Lint do
  use Mix.Task

  @shortdoc "Runs excoveralls and checks coverage"
  @preferred_cli_env :test

  alias Mix.Tasks.Coveralls.Lint.CLI.ArgsParser

  @impl Mix.Task
  def run(args, options \\ []) do
    linter_fn = Keyword.get(options, :linter_fn, &ExCoverallsLinter.run/1)
    exit_fn = Keyword.get(options, :exit_fn, &exit/1)
    shell_io = Keyword.get(options, :shell_io, Mix.Shell.IO)

    case do_run(args, linter_fn) do
      :ok ->
        shell_io.info("OK")
        :ok

      {:error, errors} ->
        print_errors(errors, shell_io)
        exit_fn.({:shutdown, 1})
        {:error, errors}
    end
  end

  defp do_run(args, linter_fn) do
    args
    |> ArgsParser.parse()
    |> rule_specs()
    |> linter_fn.()
  end

  defp rule_specs(options) do
    [
      {ExCoverallsLinter.Rules.MissedFile, [required_coverage: options[:required_file_coverage]]},
      {ExCoverallsLinter.Rules.MissedCodeBlock,
       [missed_lines_threshold: options[:missed_lines_threshold]]}
    ]
  end

  defp print_errors(errors, shell_io) do
    for error <- errors do
      shell_io.error(to_string(error))
    end

    :ok
  end
end
