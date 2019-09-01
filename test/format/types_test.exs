defmodule TestExpFormatTypes do
    use ExUnit.Case
    alias Exp.Format.Types
    doctest Types

    
    describe "test/build-entries" do

         test "valid" do
            # Should throw error because not all required fields are filled
            assert Types.build_entry({[title: "Value"], [], []}) == ["01.09.2019", "Value", ]
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




end