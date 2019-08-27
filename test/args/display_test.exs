defmodule TestPowArgsDisplay do
    use ExUnit.Case
    alias Pow.Action.State
    alias Pow.Args.Display
    doctest Display

    setup do
        State.start_link()
        State.write_entry({Time.utc_now(), "Hello World"})
        State.write_entry({Time.utc_now(), "What in the world"})

        :ok
    end

    def teardown do
        State.flush(:config_store)
        State.flush(:entry_store)
        State.shutdown()
    end


    test "show-all/no-param/valid" do
        assert Display.parse(:show, []) != []
        teardown()
    end

    test "show-all/param/valid" do
        assert Display.parse(:show, ["-a"]) == []
        teardown()
    end

    test "get-entries/all/valid" do
        assert true
    end

    test "get-entries/filter/valid" do
        assert true
    end
    
end