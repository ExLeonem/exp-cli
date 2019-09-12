defmodule Exp.Format.FileOutput do
    @moduledoc """
        Formatting the export of entry tables to output files.
    """

    # Add to config.exs and make configurable
    @opts [
        csv: [sep: ",", field_names: []],
        json: [],
        xml: [],
        yaml: []    
    ]
    


    # What todo on nested keys?
    def header(:csv, keys) when not is_list(keys), do: raise ArgumentError, message: "Error in function &header/2. Expected an array of header keys, got something else."
    def header(:csv, keys) do
        keys |> Enum.map(&to_string/1) |> Enum.join(",")    
    end

    
    @doc """
        Parses the given data to the output format.

        Parameters
        - output_format: atom representing the output format [:csv | :json | :xml]
        - data: given entry data
        - opts: additional options to set
            - sep: separator for :csv type
            - field_names: column names for :csv
        

        TODO: Merge default config into passed config
    """
    def format(type, data) do

        if length(data) != 0 do
            result = type |> resolve(data) 
            {:ok, result}
        else
            {:error, "Nice try. Record something before trying to write it into a file."}
        end
        # Append header additional header if :field_names passed
        # if is_list(opts[:field_names]) && !Enum.empty?(opts[:field_names]) do
        #     csv_header = header(type, opts[:field_names])
        #     csv_header <> "\n" <> csv_content
        # else
        #     csv_content 
        # end
    end

    @doc """
        Dispatches on different resolve functions depending on the file extension.

        Returns the resolved entries into the specific file format.
    """
    def resolve(type, data) do
        case type do
            :csv -> resolve_csv(data)
            :json -> resolve_json(data)
            :xml -> resolve_xml(data)
            :yaml -> resolve_yaml(data)
        end
    end

    @doc """
        Function resolves and writes entry into one line. Formatting the output.

        Parameters:
        - data: data to be resolved
        - acc: accumulator for the string

        Returns resolved string ready to be written to a file.
    """
    def resolve_csv(data, acc \\ "")
    def resolve_csv([], acc), do: acc
    def resolve_csv([value | rest], acc) when is_tuple(value) do

        resolve_inner = fn 
            value when is_tuple(value) or is_list(value) -> 
                joined_values = value |> to_list |> Enum.join(@opts[:csv][:sep])
                "[#{joined_values}]"
            value -> value |> to_string |> encapsulate? end   
        
        new_acc = value
        |> to_list
        |> Enum.map(resolve_inner)
        |> Enum.join(@opts[:csv][:sep])
        |> combine(acc)

        resolve_csv(rest, new_acc)
    end
    def resolve_csv(_, _), do: raise ArgumentError, message: "Error in function &resolve_csv/3. Invalid entry format. Only mulitple entries represented as tuple may be written to a file."


    def resolve_xml(data), do: {:error, "Currently under development"}
    def resolve_yaml(data), do: {:error, "Currently under development"}
    def resolve_json(data), do: {:error, "Currently under development"}



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