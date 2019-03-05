defmodule StreamPgKinesisTest do
  use ExUnit.Case
  doctest StreamPgKinesis

  test "greets the world" do
    assert StreamPgKinesis.hello() == :world
  end
end
