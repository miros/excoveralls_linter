defmodule Mix.Tasks.Coveralls.LintTest do
  use ExUnit.Case

  alias Mix.Tasks.Coveralls.Lint

  defmodule FakeShellIO do
    def info(_msg), do: :ok
    def error(_msg), do: :ok
  end

  test "it exits with error when linting fails" do
    linter_fn = fn _args ->
      {:error, ["some-error"]}
    end

    exit_fn = fn reason ->
      assert reason == {:shutdown, 1}
    end

    assert {:error, _} =
             Lint.run(["--max-missed-lines=1", "--required-file-coverage=0.9"],
               linter_fn: linter_fn,
               exit_fn: exit_fn,
               shell_io: FakeShellIO
             )
  end
end
