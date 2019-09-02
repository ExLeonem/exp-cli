defmodule TestExpMainParser do
  use ExUnit.Case
  alias Exp.Args.Main
  alias Exp.Action.State
  doctest Exp.CLI

  setup do
    State.start_link()
    State.init_config()
    :ok
  end

  def teardown do
    State.flush(:config_store)
    State.flush(:entry_store)
    State.shutdown()
  end


  # # valid start no recording process currently running
  # test "dispatch/start/valid/default" do
  #   assert {:ok, _} = Main.parse(["start"])
  #   teardown()
  # end

  # test "dispatch/start/invalid" do
  #   Main.parse(["start"])
  #   assert {:error, _} = Main.parse(["start"])
  #   teardown()
  # end

  # test "dispatch/get/valid" do
  #   assert {:ok, ["1:30"]} = Main.parse(["get", "--block-length"])
  # end

  # test "dispatch/get/invalid" do
  #   assert {:error, _} = Main.parse(["get", "--wahtever"])
  # end

  # test "dispatch/set/valid" do
  #   assert {:ok, _} = Main.parse(["set", "--block-length", "2:00"])
  # end

  # # Should throw error
  # test "dispatch/set/invalid-value" do
  #   assert {:error, _} = Main.parse(["set", "--block-length", "hl"])
  # end

  # test "dispatch/set/invalid-key" do
  #   assert {:error, _} = Main.parse(["set", "--hello", "value"])
  # end

end
