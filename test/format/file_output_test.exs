defmodule TestExpFormatFileOutput do
    use ExUnit.Case
    alias Exp.Format.FileOutput
    doctest FileOutput


    describe "test/csv-output" do

        test "single/integer" do
            assert FileOutput.format(:csv, 22) == "22"
        end

        test "single/boolean" do
            assert FileOutput.format(:csv, true) == "true"
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

    describe "test/utilities" do
        
        test "collection/valid/list" do
            assert FileOutput.is_collection?(["a", "c"]) == true
        end

        test "collection/valid/tuple" do
            assert FileOutput.is_collection?({1,2,3}) == true
        end

        test "collection/valid/map" do
            assert FileOutput.is_collection?(%{"a" => 12}) == true
        end

        test "collection/invalid" do
            assert FileOutput.is_collection?(12) == false
        end

        test "to_list/valid/tuple" do
            assert FileOutput.to_list({1, 2, 3}) |> is_list == true
        end

        test "to_list/valid/map" do
            assert FileOutput.to_list(%{"a" => 12}) |> is_list == true
        end

        test "to_list/valid/list" do
            assert FileOutput.to_list([1, 2, 3]) |> is_list == true
        end

        test "to_list/invalid/atomic" do
            assert_raise FunctionClauseError, fn ->
                FileOutput.to_list(1)
            end
        end

    end



end