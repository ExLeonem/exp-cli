defmodule Exp.Format.FileOutput do
    alias Exp.Format.Config
    @moduledoc """
        Formatting the export of entry tables to output files.
    """

    @field_names Config.extract(:keys, :field)


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
        
        cond do
            is_list(data) -> data |> resolve_csv(opts)
            is_tuple(data) -> data |> Tuple.to_list |> resolve_csv(opts)
            is_map(data) -> data |> Map.to_string |> resolve_csv(opts)
            true -> data |> to_string
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
    def resolve_csv(data, opts \\ [], acc \\ "")
    def resolve_csv([], _, acc), do: acc
    def resolve_csv([value | rest], opts, acc) do

        if !is_collection?(value) do
            # Not a collection append and recurse

        else
            
        end
    end



    # XML|CSV specific
    def create_header(type, keys) do
        
    end

    # Check if passed data is collection
    def is_collection?(data) when is_list(data) or is_map(data) or is_tuple(data), do: true
    def is_collection?(_), do: false

    # Transforms different collections to list
    def to_list(data) when is_list(data), do: data
    def to_list(data) when is_map(data), do: data |> Map.to_list
    def to_list(data) when is_tuple(data), do: data |> Tuple.to_list

end