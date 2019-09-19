defmodule TestExpFormatCLI do
    use ExUnit.Case, async: true
    alias Exp.Format.CLI

    describe "status-output" do
        
        test "error/valid" do
            assert {:error, _} = CLI.error("something")
        end

        test "ok/valid" do
            assert {:ok, _} = CLI.ok("something")
        end

        test "warn/valid" do
            assert {:error, _} = CLI.warn("something")
        end
    end

end