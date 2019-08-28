defmodule TestPowArgsDisplay do
    use ExUnit.Case
    alias Pow.Action.State
    alias Pow.Args.Display
    doctest Display

    setup do
        State.start_link()
        :ok
    end

    def teardown do
        State.flush(:config_store)
        State.flush(:entry_store)
        State.shutdown()
    end

    def load_mock_data() do
        State.write_entry({Time.utc_now(), "Hello World"})
        State.write_entry({Time.utc_now(), "What in the world"})
        State.write_entry({Time.utc_now(), "k"})
        State.write_entry({Time.utc_now(), "nkn"})
        State.write_entry({Time.utc_now(), "tt"})
        now = Time.utc_now()
        State.write_entry({now, "cc"})
        State.put_config(:last_entry, now)
    end


    describe "test :show" do        

        test "no-param/valid" do
            load_mock_data()
            assert Display.parse(:show, []) != []
            teardown()  
        end

        test "no-param/invalid" do
            assert Display.parse(:show, []) == []
            teardown()
        end

        test "param[:all]/valid" do
            load_mock_data()
            assert Display.parse(:show, ["-a"]) != []
            teardown()
        end

        test "param[:all]/invalid" do
            assert Display.parse(:show, ["-a"]) == []
            teardown()
        end

        test "param[:last]/valid/empty" do
            teardown()
            State.start_link()
            load_mock_data()
            assert [{_, "cc"}] = Display.parse(:show, ["-l"])
            teardown()
        end

    end


    describe "test :get" do

        test "get-entries/all/valid" do
            assert true
        end

        test "get-entries/filter/valid" do
            assert true
        end

    end
    
end