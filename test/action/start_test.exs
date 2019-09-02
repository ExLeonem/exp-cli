defmodule TestExpActionRecordStart do
    use ExUnit.Case
    alias Exp.Action.State
    alias Exp.Action.Record.Start
    doctest Start

    # Start Agent and reset everything
    setup do
        State.start_link()
        State.flush(:config_store)
        State.flush(:entry_store)
        State.init_config()
        :ok
    end

    def teardown do
        State.flush(:config_store)
        State.flush(:entry_store)
        State.shutdown()
    end

    test "start-recording/valid" do
        assert {:ok, _} = Start.start([], [])
        teardown()
    end

    test "start-recording/invalid" do
        Start.start([],[])
        assert {:error, _} = Start.start([], [])
        teardown()
    end


end