defmodule Exp.Format.FileOutput do
    @moduledoc """
        Formatting the export of entry tables to output files.
    """

    def header(type, keys) do
        
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

        Function resolves and writes entry into one line. Formatting the output.

        Parameters:
        - output_format: type of output [:csv | :json | :xml]

        Returns String
    """
    def resolve_csv(data, opts \\ [], acc \\ "")
    def resolve_csv(value, opts, acc) when is_binary(value), do: value
    def resolve_csv([], _, acc), do: acc
    def resolve_csv([value | rest], opts, acc) do

        if !is_collection?(value) do

            # If string value includes separator, encapsulate content
            new_acc = value 
                |> to_string 
                |> encapsulate?
                |> combine(acc, opts[:sep])

            # to_add = if acc == "", do: string_value, else: ","<> string_value
            # new_acc = acc <> to_add
            resolve_csv(rest, opts, new_acc)
        else
            # Recurse, resolve only to a specific level
            value
            |> to_string
            |> resolve_csv(opts, acc)
        end
    end

    # Combines left and right string parts, takes only strings
    def combine(right, "", _), do: right
    def combine(right, left, sep), do: left <> sep <> right

    # Check if passed data is collection
    def is_collection?(data) when is_list(data) or is_map(data) or is_tuple(data), do: true
    def is_collection?(_), do: false

    # Transforms different collections to list
    def to_list(data) when is_list(data), do: data
    def to_list(data) when is_map(data), do: data |> Map.to_list
    def to_list(data) when is_tuple(data), do: data |> Tuple.to_list

    # Value contains comma? return value encapsulated in double commata
    # TODO: catch double quotes in text too??
    def encapsulate?(value) do
        has_commata? = Regex.match?(~r/\,/, value)

        if has_commata? do
            "\"" <> value <> "\""
        else
            value
        end
    end


end