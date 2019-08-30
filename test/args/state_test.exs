defmodule TestExpArgsState do
  use ExUnit.Case
  alias Exp.Action.State, as: StateAgent
  alias Exp.Args.State, as: ArgsState
  doctest Exp.Args.State


  setup do
    StateAgent.start_link()
    :ok
  end

  def teardown() do
    StateAgent.shutdown()
  end 


  describe "test/set-parameters" do

    test "set/:block-length" do
      ArgsState.parse(:set, ["--block-length", "20:00"])
      assert StateAgent.get_config(:block_length) == [block_length: "20:00"]
      teardown()
    end

    test "test/:remind" do
      ArgsState.parse(:set, ["--remind", "2:00"])
      assert StateAgent.get_config(:remind) == [remind: "2:00"]
      teardown()
    end

  end


  describe "test/get-parameters" do
    
  end


end
