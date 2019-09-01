defmodule TestExpArgsRecord do
  use ExUnit.Case
  alias Exp.Args.Record
  doctest Exp.Args.Record


  test "add/valid" do
    assert {:ok, _} = Record.parse(:add, ["--title", "Hello World or nah", "--date", "22.10.2019"])
  end

  test "add/invalid" do
    assert {:error, _} = Record.parse(:add, ["-some", "what in the world"])
  end

  # test "start/default" do
  #   assert Record.start() = {:ok, "", []}
  # end

  # # A process was already started
  # test "start/invalid" do

  # end


  # #
  # test "start/timer/valid" do

  # end


  # test "start/timer/invalid" do

  # end


  # test "start/timer/remind/valid" do


  # end


  

end
