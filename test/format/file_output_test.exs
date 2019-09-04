defmodule TestExpFormatFileOutput do
    use ExUnit.Case
    alias Exp.Format.FileOutput
    doctest FileOutput


    describe "test/csv-output" do

        test "single/integer" do
            assert FileOutput.format(:csv, 22) == "21"
        end

        test "single/boolean" do
            assert FileOutput.format(:csv, true) == "none"
        end

        test "collection/tuple" do
            assert FileOutput.format(:csv, {1, 2}) == "1,2"
        end

        test "nested/tuple" do
            assert FileOutput.format(:csv, {1, {2, 3}}) == "1,[2,3]"
        end

        test "collection/list" do
            assert FileOutput.format(:csv, [1, 2]) == "1,2"
        end

        test "nested/list" do
            assert FileOutput.format(:csv, [1, [2, 3]]) == "1,[2,3]"            
        end

        test "valid-opt-separator" do
            assert FileOutput.format(:csv, [1, 2, 3], [sep: ";"]) == "1;2;3"
        end

        test "invalid-separator" do
            assert FileOutput.format(:csv, [1, 3, 4], [sep: true]) == false
        end

    
    end


    describe "test/json-output" do
        
    end


    describe "yaml" do
        
    end


end