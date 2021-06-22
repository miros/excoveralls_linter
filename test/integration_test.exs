defmodule IntegrationTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  @tag runs_coveralls: true
  test "successfully runs command" do
    capture_io(fn ->
      assert :ok ==
               Mix.Task.run("coveralls.lint", [
                 "--missed-lines-threshold=100",
                 "--required-file-coverage=0.0"
               ])
    end)
  end
end
