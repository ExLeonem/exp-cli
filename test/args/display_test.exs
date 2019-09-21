defmodule TestExpArgsDisplay do
    use ExUnit.Case
    alias Exp.Action.State
    alias Exp.Args.Display
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
        c_mock_entry("Hello world")
        c_mock_entry("whatever")
        c_mock_entry("nkn")
        c_mock_entry("tt")
        last_entry = c_mock_entry("cc")
        State.put_config(:last_entry, last_entry)
    end

    def c_mock_entry(title, tags \\ "") do
        dt = DateTime.utc_now()
        entry = {dt, dt, dt, title, tags, "10:10"}
        State.write_entry(entry)
        entry
    end


    describe "test :show" do        

        test "no-param/valid" do
            load_mock_data()
            assert Display.parse(:show, []) != []
            teardown()  
        end

        test "no-param/invalid" do
            assert {:ok, _} = Display.parse(:show, [])
            teardown()
        end

        test "param[:all]/valid" do
            load_mock_data()
            assert Display.parse(:show, ["-a"]) != []
            teardown()
        end

        test "param[:all]/invalid" do
            assert {:ok, _} =  Display.parse(:show, ["-a"])
            teardown()
        end

        test "param[:last]/valid/empty" do
            teardown()
            State.start_link()
            load_mock_data()
            assert {:ok, _} = Display.parse(:show, ["-l"])
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