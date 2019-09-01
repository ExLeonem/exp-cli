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
                Types.set_type(context[:schema], :wtf)
            end
        end

    end


    describe "test/get-command-definitions" do
        
        # test "valid-definition" do
        # #     command_defintion = Types.extract(:add, :command)
        # end


    end
    
    describe "test/get-field-definitions" do
        
        test "get/schema" do
            assert Types.extract(:schema, :fields) |> Keyword.get(:tag) == :string
        end

        test "get/schema/exclude" do
            assert Types.extract(:schema, :fields, [exclude: [:tag]]) |> Keyword.has_key?(:tag) == false
        end

        test "get/schema/exclude-invalid-param" do

            assert_raise ArgumentError, fn ->
                Types.extract(:schema, :fields, 22) == false
            end
        end

        test "get/schema/exclude-invalid-param-list" do
            assert Types.extract(:schema, :fields, [22]) != []
        end

        test "get/required?" do
            assert Types.extract(:required, :fields) |> Keyword.get(:start) == true
        end

        test "get/required?/exclude" do
            assert Types.extract(:required, :fields, [exclude: [:date]]) |> Keyword.has_key?(:date) == false
        end

        test "get/invalid/exclude" do
            assert_raise ArgumentError, fn ->
                Types.extract(:schema, :fields, [exclude: 22]) == false
            end
        end

        test "get/unknown-action" do
            assert_raise ArgumentError, fn ->
                Types.extract(:some, :fields) == false
            end
        end

        test "get/alias" do
            assert Types.extract(:alias, :fields) |> Keyword.get(:t) == :title
        end

        test "get/alias/:none-always-filtered" do
            assert Types.extract(:alias, :fields) |> Keyword.has_key?(:none) == false
        end


    end

end