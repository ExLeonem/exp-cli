defmodule ExpTestFormatTypes do
    use ExUnit.Case
    alias Exp.Format.Types
    doctest Exp.Format.Types

    

    describe "test/config-operations" do
        
        test "get-default-values" do
            assert Types.extract(:defaults) |> Keyword.get(:output_format) == :csv  
        end

        test "extract-writes?" do
            assert Types.extract(:write) |> Keyword.get(:block_length) == true
        end

        test "extract-keys" do
            assert :time_started in Types.extract(:keys)
        end

        test "extract-schema" do
            assert Types.extract(:schema) |> Keyword.get(:last_entry) == :string
        end

        test "extract-invalid-action" do
            assert Types.extract(:do_something) == Application.get_env(:exp, :params, nil)
        end

    end



    describe "test/set-types" do
    
        setup do
            schema = Types.extract(:schema)
            [schema: schema]
        end
        
        test "set/default-boolean", context do
            new_schema = Types.set_type(context[:schema])
            assert new_schema |> Keyword.get(:output_format) == :boolean
        end

        test "set/string", context do
            new_schema = Types.set_type(context[:schema], :string)
            assert new_schema |> Keyword.get(:is_recording) == :string
        end

        test "set/integer", context do
            new_schema = Types.set_type(context[:schema], :integer)
            assert new_schema |> Keyword.get(:last_entry)  == :integer
        end

        test "set/type", context do
            new_schema = Types.set_type(context[:schema], :float)
            assert new_schema |> Keyword.get(:version) == :float
        end

        test "set/unknown-type", context do
            assert_raise ArgumentError, fn ->
                new_schema = Types.set_type(context[:schema], :wtf)
            end
        end





    end


end