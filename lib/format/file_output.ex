defmodule Exp.Format.FileOutput do
    alias Exp.Format.Config

    @moduledoc """
        Formatting the export of entry tables to output files.
    """

    def write_file(data, opts \\ [format: :csv, dir: "./"]) do

    end


    @doc """
        Parses the given data to the output format.

        Parameters
        - output_format: atom representing the output format [:csv | :json | :xml]
        - data: given entry data
        
    """
    def format(type, data, opts \\ [sep: ",", field_names: []])
    def format(:csv = type, data, opts) do
        content = ""
        
        if is_list(data) || is_map(data) || is_tuple(data) do
            type |> resolve(data)s
        else

        end
    end

    def format(:json, data, opts) do
        
    end

    def format(:xml, data, opts) do
        
    end


    @doc """

        Parameters:
        - output_format: type of output [:csv | :json | :xml]
    """
    def resolve(type, data, acc \\ [], opts \\ [])
    def resolve(_, [], acc), do: acc
    def resolve(:csv, [field| rest], acc) do
        
    end


    # XML|CSV specific
    def create_header(type, keys) do
        
    end

end