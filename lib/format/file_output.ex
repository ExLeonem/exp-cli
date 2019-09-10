defmodule Exp.Format.FileOutput do
    @moduledoc """
        Formatting the export of entry tables to output files.
    """

    # What todo on nested keys?
    def header(:csv, keys) do
        keys |> Enum.map(&to_string/1) |> Enum.join(",")    
    end

    
    @doc """
        Parses the given data to the output format.

        Parameters
        - output_format: atom representing the output format [:csv | :json | :xml]
        - data: given entry data
        
    """
    def format(type, data, opts \\ [sep: ",", field_names: []])
    def format(:csv = type, data, opts) do
        data |> resolve_csv(opts, "")
    end

    def format(:json, data, opts), do: {:help, "This feature is currently under development."}
    def format(:xml, data, opts), do: {:help, "This feature is currently under development."}
    def format(:yaml, data, opts), do: {:help, "This feature is currently under development."}



    @doc """
        Function resolves and writes entry into one line. Formatting the output.

        Parameters:
        - data: data to be resolved
        - opts: additional options used while processing the data
            - sep: separator to be used, needs to be a string
            - field names: needs to be equally long as entity type length
        - acc: accumulator for the string

        Returns resolved string ready to be written to a file.
    """
    def resolve_csv(data, opts \\ [], acc \\ "")
    def resolve_csv([], _, acc), do: acc
    def resolve_csv([value| rest], opts, acc) when is_tuple(value) do

        resolve_inner = fn 
            value when is_tuple(value) or is_list(value) -> 
                joined_values = value |> to_list |> Enum.join(opts[:sep])
                "[#{joined_values}]"
            value -> value |> to_string |> encapsulate? end   
        
        new_acc = value
        |> to_list
        |> Enum.map(resolve_inner)
        |> Enum.join(opts[:sep])
        |> combine(acc)

        resolve_csv(rest, opts, new_acc)
    end
    
    def resolve_csv(_, _, _), do: raise ArgumentError, message: "Error in function &resolve_csv/3. Invalid entry format. Only mulitple entries represented as tuple may be written to a file."

    # Combines left and right string parts, takes only strings
    def combine(right, ""), do: right
    def combine(right, left), do: left <> "\n" <> right

    # Check if passed data is collection
    def is_collection?(data) when is_list(data) or is_map(data) or is_tuple(data), do: true
    def is_collection?(_), do: false

    # Transforms different collections to list
    def to_list(data) when is_list(data), do: data
    def to_list(data) when is_map(data), do: data |> Map.to_list
    def to_list(data) when is_tuple(data), do: data |> Tuple.to_list

    @doc """
        Value contains commata. Needs to be encapsulated in ""

        # Value contains comma? return value encapsulated in double commata
        # TODO: catch double quotes in text too??
        returns encapsulated string
    """
    def encapsulate?(value) when not is_binary(value), do: value
    def encapsulate?(value) when is_binary(value) do
        has_commata? = Regex.match?(~r/\,/, value)

        if has_commata? do
            "\"" <> value <> "\""
        else
            value
        end
    end


end