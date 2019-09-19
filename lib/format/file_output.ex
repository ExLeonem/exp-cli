defmodule Exp.Format.FileOutput do
    alias Exp.Format.Config
    alias Exp.Format.Types
    
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
    def resolve_csv([value | rest], acc) when is_tuple(value) or is_list(value) do
        
        # Resolve unecessary nesting
        new_value = if is_tuple(value), do: value, else: hd(value)

        resolve_inner = fn 
            value when is_tuple(value) or is_list(value) -> 
                joined_values = value |> to_list |> Enum.join(@opts[:csv][:sep])
                "\"[#{joined_values}]\""

            value -> 
                value |> to_string |> encapsulate? 
            end   
        
        new_acc = new_value
        |> to_list
        |> Enum.map(resolve_inner)
        |> Enum.join(@opts[:csv][:sep])
        |> combine(acc)

        resolve_csv(rest, new_acc)
    end
    def resolve_csv(_, _), do: raise ArgumentError, message: "Error in function &resolve_csv/3. Invalid entry format. Only mulitple entries represented as tuple may be written to a file."


    @doc """
        Resolves a list of entities or a single entity into a json format.

        {
            data: [
                entity,
                entity
            ]
        }

        returns a string
    """
    def resolve_json(data, acc \\ "{\"data\":[")
    def resolve_json([], acc), do: acc <> "]}"
    def resolve_json([value | rest], acc) do
        keys = Config.extract(:keys, :field) |> Enum.reverse
        all_keys = [:duration | keys]

        entry = if is_tuple(value), do: value |> to_list, else: hd(value) |> to_list 
        zipped_values = all_keys |> Enum.zip(entry)

        resolve_inner = fn 
            {key, value} when is_tuple(value) or is_list(value) ->
                # nested value
                IO.puts("resolve nested")
                joined_values = value |>Enum.map(&enc_value/1) |> Enum.join(",")
                list_of_values = "[#{joined_values}]"
                combine_key_value(key, list_of_values)

            {key, value} ->
                IO.puts("resolve simple")
                IO.inspect(key)
                IO.inspect(value)
                # combine_key_value(key, value)
                IO.puts("finished")
            _ -> 
                IO.puts("something else")    
            end

        new_acc = zipped_values
            |> Enum.map(resolve_inner)
            

        resolve_json(rest, acc <> new_acc)
    end
    def resolve_json(_, _), do: raise ArgumentError, message: "Error in function &resolve_json/3. Invalid entry format. Only mulitple entries represented as tuple may be written to a file."
    

    def flatten_list() do
        
    end

    def combine_key_value(key, value) do
        enc_value(key) <> ":" <> value
    end

    def enc_value(item, type \\ :string)
    def enc_value(item, :string), do: "\"" <> item <> "\""
    def enc_value(item, :object), do: "{" <> item <> "}"
    



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