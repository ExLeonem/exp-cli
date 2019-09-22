defmodule TestExpActionFile do
    use ExUnit.Case
    alias Exp.Action.State
    alias Exp.Args.Record
    alias Exp.Action.File, as: ExpFile
    doctest File

    def clean(path) do
        File.rm_rf(path)
    end

    def mock() do
        Record.parse(:add, ["--start", "12:12", "--end", "22:22", "--title", "Hello world"])
        Record.parse(:add, ["--date", "22-10-2019","--start", "12:12", "--end", "10:32", "--title", "Whatever", "--tag", "one,two,three"]) # Must throw error?
        Record.parse(:add, ["--date", "23-10-2019", "--start", "12:12", "--end", "18:25", "--title", "Whatever", "--tag", "one,two,three"])
        Record.parse(:add, ["--date", "24-10-2019", "--start", "12:12", "--end", "18:25", "--title", "Whatever", "--tag", "git,programming,pomodoro"])
    end

    def teardown() do
        State.flush(:config_store)
        State.flush(:entry_store)
        State.shutdown()
    end

    describe "test &write/2" do
        
        setup do
            State.start_link()
            {:ok, path} = File.cwd()
            mock()
            [
                default_path: path
            ]
        end


        test "valid/csv", config do
            file_path = [config[:default_path], "test.csv"] |> Path.join
            IO.puts(file_path)
            assert ExpFile.write({:ok, [output: file_path]}) == false
            teardown()
        end

    end

end