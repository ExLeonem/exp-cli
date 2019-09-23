defmodule TestExpArgsFile do
    use ExUnit.Case
    alias Exp.Action.State
    alias Exp.Args.File
    alias Exp.Args.Record
    doctest File

    def mock_data() do
        Record.parse(:add, ["--start", "12:12", "--end", "22:22", "--title", "Hello world"])
        Record.parse(:add, ["--date", "22-10-2019","--start", "12:12", "--end", "10:32", "--title", "Whatever", "--tag", "one,two,three"])
        Record.parse(:add, ["--start", "12:12", "--end", "18:25", "--title", "Whatever", "--tag", "one,two,three"])
        Record.parse(:add, ["--start", "12:12", "--end", "18:25", "--title", "Whatever", "--tag", "git,programming,pomodoro"])
    end

    def teardown() do
        State.flush(:config_store)
        State.flush(:entry_store)
        State.shutdown()
    end

    describe "test &parse/2" do

        setup do
            State.start_link()
            :ok
        end

        test "invalid/no-extension" do
            assert {:error, _} = File.parse(:write, ["/home/maksim/Desktop/test"])
            teardown()
        end

        test "invalid/non-existent-path-component" do
            mock_data()
            assert {:error, _} = File.parse(:write, ["/home/maksim/Desktop/somewhere/test.csv"])
            teardown()
        end

        test "valid/help" do
            assert {:help, _} = File.parse(:write, ["-h"])
            teardown()
        end

        test "invalid/no-params" do
            assert {:error, _} = File.parse(:write, [])
            teardown()
        end

    end

end