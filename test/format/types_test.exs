defmodule TestExpFormatTypes do
    use ExUnit.Case
    alias Exp.Format.Types
    doctest Types

    def parser_mock(parsed, rest \\ [], errors \\ []) do
        {parsed, rest, errors}
    end

    
    describe "test/build-entries" do

        setup do
            [ valid: [title: "Value", start: "12:12", end: "14:14"] ]
        end


        test "valid/default", context do
            params = context[:valid] |> parser_mock
            assert {:ok, _} = Types.build_entry(params)
        end

        test "valid/all-filled", context do
            params = context[:valid] |> Keyword.put(:tag, "tag1,tag2,tag3") |> Keyword.put(:end, "22:22") |> parser_mock
            assert {:ok, _} = Types.build_entry(params)
        end

        test "valid/set-date", context do
            params = context[:valid] |> Keyword.put(:date, "22-10-2019") |> parser_mock
            assert {:ok, _} = Types.build_entry(params)
        end

        test "invalid/unknown-parameters", context do
            assert {:error, _} = Types.build_entry({context[:valid], [some: "other"], []})
        end

        test "invalid/parse-errors", context do
            assert {:error, _} = Types.build_entry({context[:valid], [], [some: "value"]})
        end

        test "invalid/missing-required-fields" do
            # Should throw error because not all required fields are filled
            assert {:error, _} = Types.build_entry({[title: "Value"], [], []})
        end

        test "invalid/all-empty" do
            assert {:error, _} = Types.build_entry({[],[],[]})
        end

        test "rest/invalid-params" do
            assert {:error, _} = Types.build_entry({[], [some: "value"], []})
        end

        test "invalid/params" do
            assert {:error, _} = Types.build_entry({[], [], [error: "wtf"]})
        end

    end

    describe "test/utilities/empty?" do
        
        test "true/empty_string" do
            assert Types.empty?("") == true
        end 

        test "true/nil" do
            assert Types.empty?(nil) == true
        end

        test "false/numeric" do
            assert Types.empty?(234) == false
        end

        test "false/string" do
            assert Types.empty?("something") == false
        end

        test "false/boolean" do
            assert Types.empty?(false) == false
        end

        test "true/list" do
            assert Types.empty?([]) == true
        end

        test "false/list" do
            assert Types.empty?([1, 2]) == false
        end

        test "true/map" do
            assert Types.empty?(%{}) == true
        end

        test "false/map" do
            assert Types.empty?(%{"val" => 10}) == false
        end

    end

    describe "test/utilities/valid?" do
        
        test "true/float" do
            assert Types.valid?(2.2, :float) == true
        end 

        test "false/float/try-cast-break" do
            assert Types.valid?("break?", :float) == false
        end

        test "true/float-string" do
            assert Types.valid?("2.2", :float) == true
        end
        
        test "false/float" do
            assert Types.valid?(1, :float) == false
        end

        test "true/string" do
            assert Types.valid?("he") == true
        end 

        test "false/string" do
            assert Types.valid?('15') == false
        end

        test "true/integer" do
            assert Types.valid?(12, :integer) == true
        end

        test "false/integer/try-cast-break" do
            assert Types.valid?("break?", :integer) == false
        end

        test "false/integer" do
            assert Types.valid?(12.5, :integer) == false
        end

        test "true/date" do
            assert Types.valid?("12-12-2019", :date) == true
        end

        test "false/date/wrong-dividers" do
            assert Types.valid?("12.12.2019", :date) == false
        end

        test "false/date/invalid-format/12.2019" do
            assert Types.valid?("12.2019", :date) == false
        end

        test "false/date/invalid-format/2019" do
            assert Types.valid?("2019", :date) == false
        end

        test "false/date/invalid-format/empty" do
            assert Types.valid?("", :date) == false
        end

        test "false/date/is_time" do
            assert Types.valid?("h", :date) == false
        end

        test "false/date/invalid_type" do
            assert Types.valid?(true, :date) == false
        end

        test "true/time/valid" do
            assert Types.valid?("12:15", :time) == true
        end

        test "false/time/invalid" do
            assert Types.valid?("12", :time) == false
        end

        test "false/time/hey" do
            assert Types.valid?("hey", :time) == false
        end

        test "false/time/invalid-type" do
            assert Types.valid?(true, :time) == false
        end

    end
end 