defmodule TestExpArgsState do
  use ExUnit.Case
  alias Exp.Action.State, as: StateAgent
  alias Exp.Args.State, as: ArgsState
  alias Exp.Format.DateTime, as: ExpDateTime
  doctest Exp.Args.State

  setup do
    StateAgent.start_link()
    :ok
  end

  def mock_data() do
      c_mock_entry("Hello world")
      c_mock_entry("whatever")
      c_mock_entry("nkn")
      c_mock_entry("tt")
      last_entry = c_mock_entry("cc")
      StateAgent.put_config(:last_entry, last_entry)
  end

  def c_mock_entry(title, tags \\ "") do
      dt = ExpDateTime.now()
      entry = {dt, dt, dt, title, tags, "10:10"}
      StateAgent.write_entry(entry)
      entry
  end

  def teardown() do
    StateAgent.flush(:entry_store)
    StateAgent.flush(:config_store)
    StateAgent.shutdown()
  end 

  describe "test/set-parameters" do

    test "set/:block-length" do
      ArgsState.parse(:set, ["--block-length", "20:00"])
      assert StateAgent.get_config(:block_length) == "20:00"
      teardown()
    end

    test "test/[]/no-options-set" do
      assert {:error, _} = ArgsState.parse(:set, [])
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
      assert ArgsState.parse(:get, ["--block-length", "--output-format"]) == {:ok, "1:30, csv"}
    end

    test "get/[]/no-options-set" do
      assert {:error, _} = ArgsState.parse(:get, [])
    end

    test "get/[:invalid]/help" do
      assert {:error, _} = ArgsState.parse(:get, ["--invalid"])
    end

  end

  describe "test/delete-entries" do

    setup do
      StateAgent.start_link()
      :ok
    end
    
    test "delete all" do
      mock_data()
      assert {:ok, _} = StateAgent.delete_entry({:all, ""})
      teardown()
    end

    test "delete all/ no data" do
      teardown()
      StateAgent.start_link()
      assert {:error, _} = StateAgent.delete_entry({:all, ""})
      teardown()
    end

    test "delete last" do
      mock_data()
      last_entry = StateAgent.get_last_entry()
      assert {:ok, _} = StateAgent.delete_entry({:last, ""})
      teardown()
    end

    test "delete last/ no data" do
      assert {:error, _} = StateAgent.delete_entry({:last, ""})
      teardown()        
    end

  end


end
