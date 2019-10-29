defmodule ExcoverallsLinterTest do
  use ExUnit.Case
  doctest ExcoverallsLinter

  test "greets the world" do
    assert ExcoverallsLinter.hello() == :world
  end
end
