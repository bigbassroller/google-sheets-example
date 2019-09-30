defmodule GoogleSheetsExampleTest do
  use ExUnit.Case
  doctest GoogleSheetsExample

  test "greets the world" do
    assert GoogleSheetsExample.hello() == :world
  end
end
