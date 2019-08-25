defmodule TestPowMainParser do
  use ExUnit.Case
  alias Pow.Args.Main
  doctest Pow.CLI


  # # valid start no recording process currently running
  # test "dispatch/start/valid" do
  #   assert {:ok, _msg, _params} = Main.parse(["start"])
  # end

  # # invalid recording process already running
  # test "dispatch/start/invalid" do
  #   Main.parse(["start"])
  #   assert {:error, _msg, _params} = Main.parse(["start"])
  # end

  # # valid when currently recording
  # test "dispatch/stop/valid" do
  #   Main.parse("start")
  #   assert {:ok, _msg, _params} = Main.parse("stop")
  # end

  # # eror when currently not recording
  # test "dispatch/stop/invalid" do
  #   assert {:error, _msg, _params} = Main.parse("stop")
  # end

  # # Covering invalid parameter list
  # test "dispatch/empty" do
  #   assert {:help, _msg, _params} = Main.parse("")
  # end

  # test "dispatch/nomatch" do
  #   assert {:help , _msg, _params} = Main.parse("test something else")
  # end


end
