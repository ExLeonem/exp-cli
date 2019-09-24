defmodule TestExpArgsState do
  use ExUnit.Case
  alias Exp.Action.State, as: StateAgent
  alias Exp.Args.State, as: ArgsState
  alias Exp.Format.DateTime, as: ExpDateTime
  alias Exp.Action.Record
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

  describe "test/status" do

    test "valid" do
      Record.start({[],[],[]})
      assert {:ok, _} = ArgsState.parse(:status, [])
      teardown()      
    end

    test "invalid" do
      assert {:error, _} = ArgsState.parse(:status, [])
      teardown()
    end

  end

  describe "test/delete" do
    
    test "last" do
      mock_data()
      assert {:ok, _} = ArgsState.parse(:delete, ["--last"])
      teardown()
    end

    test "all" do
      mock_data()
      assert {:ok, _} = ArgsState.parse(:delete, ["--all"])
      teardown()
    end

    test "empty" do
      mock_data()
      assert {:error, _} = ArgsState.parse(:delete, [])
      teardown()
    end

  end

  test "test/version" do
    assert {:ok, _} = ArgsState.version()
  end

end
