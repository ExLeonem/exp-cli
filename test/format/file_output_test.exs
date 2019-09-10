defmodule TestExpFormatFileOutput do
    use ExUnit.Case
    alias Exp.Format.FileOutput
    doctest FileOutput


    describe "test/csv-output" do

        test "valid/simple" do
            assert FileOutput.format(:csv, [{1, 2, 3}]) == "1,2,3"
        end

        test "valid/mixed-values" do
            assert FileOutput.format(:csv, [{1, :hey, 12.2, nil, true}]) == "1,hey,12.2,,true"
        end

        test "valid/2-entries" do
            assert FileOutput.format(:csv, [{1,2,3}, {1,2,3}]) == "1,2,3\n1,2,3"
        end

        test "valid/simple-with-header" do
            assert FileOutput.format(:csv, [{1,2,3}], [sep: ",", field_names: ["a", "b", "c"]]) == "a,b,c\n1,2,3"
        end

        test "valid/opt-separator" do
            assert FileOutput.format(:csv, [{1, 2, 3}], [sep: ";"]) == "1;2;3"
        end

        test "invalid/header" do
            assert FileOutput.format(:csv, [{1,2,3}], [sep: "/", field_names: "hey"]) == "1/2/3"
        end

        test "collection/valid/nested-values" do
            assert FileOutput.format(:csv, [{1, {2, 3}}]) == "1,[2,3]"
        end

        test "single/invalid/integer" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, 22)
            end
        end

        test "single/invalid/boolean" do
            assert_raise ArgumentError, fn -> 
                FileOutput.format(:csv, true)
            end
        end

        test "collection/invalid-format/single-tuple" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, {1, 2})
            end
        end

        test "collection/invalid/list" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, [1, 2])
            end
        end

        test "nested/list" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, [1, [2, 3]])
            end            
        end

        test "invalid-separator" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, [1, 3, 4], [sep: true]) == false
            end
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

        # &combine/2
        test "combine/valid/empty-left" do
            assert FileOutput.combine("hey", "") == "hey"
        end

        test "combine/valid/all-given" do
            assert FileOutput.combine("right", "left") == "left\nright"
        end

    end



end