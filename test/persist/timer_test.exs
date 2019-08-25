defmodule TestPowPersistTimer do
    use ExUnit.Case
    alias Pow.Persist.Timer
    doctest Timer

    test "Process not running" do
        assert Timer.alive?() == false
    end

    test "Timer shutdowns like expected" do
        Timer.start_link()
        Timer.shutdown()
        assert Timer.alive? == false
    end

    test "Process running" do
        Timer.start_link() # setup
        assert Timer.alive? == true #test
        Timer.shutdown() # tear down
    end

    test "recording default" do
        Timer.start_link
        assert Timer.recording? == false
        Timer.shutdown
    end

    test "recording true" do
        Timer.start_link(true)
        assert Timer.recording? == true
        Timer.shutdown
    end

    test "recording manual set" do
        Timer.start_link
        Timer.start()
        assert Timer.recording? == true
        Timer.shutdown
    end

end