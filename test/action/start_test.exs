defmodule TestPowActionRecordStart do
    use ExUnit.Case
    alias Pow.Action.State
    alias Pow.Action.Record.Start
    doctest Start

    # Start Agent and reset everything
    setup do
        State.start_link()
        State.flush(:config_store)
        State.flush(:entry_store)
        State.init_config()
        :ok
    end

    test "start-recording/valid" do
        assert {:ok, _} = Start.start([], [])
    end

    test "start-recording/invalid" do
        Start.start([],[])
        assert {:error, _} = Start.start([], [])
    end


end