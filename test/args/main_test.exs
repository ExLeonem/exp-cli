defmodule TestExpMainParser do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias Exp.Args.Main
  alias Exp.Action.State

  doctest Main

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

  describe "test &dispatch/2" do

    test "add" do
      assert {:ok, _} = Main.dispatch(:add, ["--start", "20:20", "--end", "22:22", "--title", "test", "--tag", "tag1,tag2,tag3"])
      teardown()
    end

    test "start" do
      assert {:ok, _} =  Main.dispatch(:start, [])
      teardown()
    end

    test "stop" do
      assert {:error, _} = Main.dispatch(:stop, ["--title", "hello"])
      teardown()
    end

    test "set" do
      assert {:ok, _} =  Main.dispatch(:set, ["--block-length", "2:30"])
      teardown()
    end

    test "get" do
      assert {:ok, _} = Main.dispatch(:get, ["--block-length"])
      teardown()
    end

    test "status" do
      assert {:error, _} = Main.dispatch(:status, [])
      teardown()
    end

    test "show" do
      assert {:ok, _} = Main.dispatch(:show, [])
      teardown()
    end

    test "-x" do
      assert {:error, _} = Main.dispatch(:"-x", [])
      teardown()
    end

  end

  test "test &process/1" do
    assert capture_io(fn -> Main.process({:get, ["--block-length"]}) end) == "1:30\n" 
  end

  test "test &parse/1" do
    no_params_msg = "I need some arguments to work. Check out exp --help to get more information.\n"
    assert capture_io(fn -> Main.parse([]) end) == no_params_msg
    teardown()
  end

  test "test &process_result/1" do
    assert capture_io(fn -> Main.process_result({:help, "hello world"}) end) == "hello world\n"
    teardown()
  end

end
