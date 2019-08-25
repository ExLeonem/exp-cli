defmodule TestPowActionRecordStart do
    use ExUnit.Case
    alias Pow.Action.Record.Start
    alias Pow.Persist.Timer
    doctest Start

    test "test process active" do
        Start.start([], [])
        assert Timer.recording? == true
    end

    test "consecutive recording should fail" do
        Start.start([], [])
        assert {:error, _} = Start.start([],[])        
    end


end