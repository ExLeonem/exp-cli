defmodule TestExpArgsRecord do
  use ExUnit.Case
  alias Exp.Args.Record
  alias Exp.Action.State
  doctest Exp.Args.Record

  setup do
    State.start_link()
    :ok
  end

  def teardown() do
    State.flush(:config_store)
    State.flush(:entry_store)
    State.shutdown()
  end

  setup do
    [valid: ["--title", "Hello World or nah", "--start", "10:10"]]
  end

  describe "test/add" do

    test "valid", context do
      assert {:ok, _} = Record.parse(:add, context[:valid])
      teardown()
    end

    test "invalid/format-error", context do
      valid = context[:valid]
      params = ["--date", "22.10.2019" | valid]
      assert {:error, _} = Record.parse(:add, params)
      teardown()
    end

    test "invalid/all-params", context do
      valid = context[:valid]
      params = ["--end", "10:20", "--tag", "tag1,tag2,tag3" | valid]
      assert {:ok, _} = Record.parse(:add, params)
      teardown()
    end

    test "invalid/missing-required" do
      assert {:error, _} = Record.parse(:add, ["-some", "what in the world"])
      teardown()
    end

    test "invalid/additional-arguments", context do
      valid = context[:valid]
      params = ["--k", "nan" | valid]
      assert {:error, _} = Record.parse(:add, params)
      teardown()
    end

  end

end
