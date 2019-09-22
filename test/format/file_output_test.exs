defmodule TestExpFormatFileOutput do
    use ExUnit.Case
    alias Exp.Action.State
    alias Exp.Format.FileOutput
    doctest FileOutput


    describe "test/csv-output" do

        setup do
            State.start_link
            :ok
        end

        def teardown do
            State.flush(:config_store)
            State.flush(:entry_store)
            State.shutdown()
        end

        test "valid/simple" do
            assert FileOutput.format(:csv, [{1, 2, 3}]) == {:ok, "date,start,end,title,tag,duration\n1,2,3"}
            teardown()
        end

        test "valid/mixed-values" do
            assert FileOutput.format(:csv, [{1, :hey, 12.2, nil, true}]) == {:ok, "date,start,end,title,tag,duration\n1,hey,12.2,,true"}
            teardown()
        end

        test "valid/2-entries" do
            assert FileOutput.format(:csv, [{1,2,3}, {1,2,3}]) == {:ok, "date,start,end,title,tag,duration\n1,2,3\n1,2,3"}
            teardown()
        end

        test "collection/valid/nested-values" do
            assert FileOutput.format(:csv, [{1, {2, 3}}]) == {:ok, "date,start,end,title,tag,duration\n1,\"[2,3]\""}
            teardown()
        end

        test "single/invalid/integer" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, 22)
            end
            teardown()
        end

        test "single/invalid/boolean" do
            assert_raise ArgumentError, fn -> 
                FileOutput.format(:csv, true)
            end
            teardown()
        end

        test "collection/invalid-format/single-tuple" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, {1, 2})
            end
            teardown()
        end

        test "collection/invalid/list" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, [1, 2])
            end
            teardown()
        end

        test "nested/list" do
            assert_raise ArgumentError, fn ->
                FileOutput.format(:csv, [1, [2, 3]])
            end
            teardown()
        end
   
    end

    describe "test/json-output" do
        
        test "valid" do
            dt = NaiveDateTime.utc_now()
            string_result = FileOutput.resolve_json([{dt,dt,dt,"4","5","10:10:10"}, {dt,dt,dt,"4","5","10:10"}]) 
            assert !is_nil(string_result)
        end

        # test "valid/nested-tags" do
        #     dt = NaiveDateTime.utc_now()
        #     assert FileOutput.resolve_json([{dt,dt,dt,"4",["tag1", "tag2"],"10:10:10"}, {dt,dt,dt,"4","5","10:10"}]) == false
        # end

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