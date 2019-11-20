defmodule IntegrationTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  test "successfully runs command" do
    capture_io(fn ->
      assert :ok ==
               Mix.Task.run("coveralls.lint", [
                 "--max-missed-lines=100",
                 "--required-file-coverage=0.0"
               ])
    end)
  end
end
