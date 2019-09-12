defmodule TestExpArgsFile do
    use ExUnit.Case
    alias Exp.Action.State
    alias Exp.Args.File
    doctest File


    describe "test/parse" do

        setup do
            State.start_link()
            :ok
        end

        def teardown() do
            State.flush(:config_store)
            State.flush(:entry_store)
            State.shutdown()
        end

        test "only/-o/valid" do
            assert File.parse(:write, ["--output", "/home/maksim/Desktop/test.csv"]) == false
            teardown()
        end

        test "only/-o/invalid/no-extension" do
            assert {:error, _} = File.parse(:write, ["--output", "/home/maksim/Desktop/test"])
            teardown()
        end

        test "only/-h/valid" do
            assert {:help, _} = File.parse(:write, ["--help"])
            teardown()
        end

        test "no-params" do
            assert {:error, _} = File.parse(:write, [])
            teardown()
        end

        test "invalid-params/" do
            assert {:error, _reason} = File.parse(:write, ["--output", "/home/maksim/Desktop/test.csv", "--dir", "/home/maksim/Desktop", "-n", "hello", "-f", ":csv"])
            teardown()
        end



    end

end