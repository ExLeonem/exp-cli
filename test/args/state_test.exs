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
    StateAgent.flush(:config_store)
    StateAgent.shutdown()
  end 


  describe "test/set-parameters" do

    test "set/:block-length" do
      ArgsState.parse(:set, ["--block-length", "20:00"])
      assert StateAgent.get_config(:block_length) == [block_length: "20:00"]
      teardown()
    end

    test "set/:remind" do
      ArgsState.parse(:set, ["--remind", "2:00"])
      assert StateAgent.get_config(:remind) == [remind: "2:00"]
      teardown()
    end

    test "set/[:remind, :block-length]" do
      ArgsState.parse(:set, ["--block-length", "20:20", "--remind", "1:00"])
      block_length = StateAgent.get_config(:block_length)
      remind = StateAgent.get_config(:remind)
      assert block_length[:block_length] == "20:20" 
      assert remind[:remind] == "1:00"
      teardown()
    end

    # Should trigger exp set --help
    test "test/[]/help" do
      assert {:help, _} = ArgsState.parse(:set, [])
      teardown()
    end

    test "test/[:invalid]/help" do
      assert {:error, _} = ArgsState.parse(:set, ["--invalid"])
      teardown()
    end

  end


  describe "test/get-parameters" do

    test "get/:block-length" do
      assert ArgsState.parse(:get, ["--block-length"]) == {:ok, "1:30"}
    end

    test "get/[:block-length, :remind]" do
      assert ArgsState.parse(:get, ["--block-length", "--remind"]) == {:ok, "1:30, nil"}
    end

    test "get/[]/help" do
      assert {:help, _} = ArgsState.parse(:get, [])
    end

    test "get/[:invalid]/help" do
      assert {:error, _} = ArgsState.parse(:get, ["--invalid"])
    end

  end


end
