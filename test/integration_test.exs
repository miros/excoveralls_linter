defmodule IntegrationTest do
  use ExUnit.Case

  test "successfully runs command" do
    assert :ok =
             Mix.Task.run("coveralls.lint", [
               "--max-missed-lines=100",
               "--required-file-coverage=0.0"
             ])
  end
end
