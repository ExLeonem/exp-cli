defmodule Exp.Format.FileOutput do
    alias Exp.Format.Config
    alias Exp.Format.Types
    alias Exp.Format.DateTime, as: ExpDateTime
    
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
    @keys Config.extract(:keys, :field)++[:duration]
    

    @doc """
        Generated a header for a specific file format.
    """
    def header(:csv) do
        @keys |> Enum.map(&to_string/1) |> Enum.join(",")   
    end

    def header(:json) do
        parsed_keys = @keys |> Enum.map(&to_string/1) |> Enum.map(&enc_value/1)
        object_attribute(:keys, parsed_keys)
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
    def resolve_csv([], acc), do: combine(acc, header(:csv))
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
            keys: [],
            data: [
                entity,
                entity
            ]
        }

        returns a string
    """
    def resolve_json(data, acc \\ "")
    def resolve_json([], acc), do: "{#{header(:json)},\"data\":[" <> acc <> "]}"
    def resolve_json([value | rest], acc) do
        entry = if is_tuple(value), do: value |> to_list, else: hd(value) |> to_list 
        zipped_values = @keys |> Enum.zip(entry)

        new_acc = zipped_values 
            |> Enum.map(&resolve_inner_json/1) 
            |> Enum.join(",")
            |> enc_value(:object)
            |> combine(acc, :json)

        resolve_json(rest, new_acc)
    end
    def resolve_json(_, _), do: raise ArgumentError, message: "Error in function &resolve_json/3. Invalid entry format. Only mulitple entries represented as tuple may be written to a file."
    
    defp resolve_inner_json({key, value}) when is_tuple(value), do: resolve_inner_json({key, Tuple.to_list(value)})
    defp resolve_inner_json({key, value}) when is_list(value) do
        values = value |> Enum.map(&enc_value/1)
        object_attribute(key, values)
    end
    defp resolve_inner_json({key, value}), do: object_attribute(key, value)


    # ------------------------------------------
    #             Utility Functions
    # ------------------------------------------

    # creates 
    def object_attribute(key, value) do
        parsed_key = key |> to_string |> enc_value
        parsed_value = value |> object_value(key) |> enc_value

        parsed_key <> " : " <> parsed_value
    end

    # Cast special values into a specific format
    def object_value(value, key) when key in [:date, :start, :end], do: ExpDateTime.to_iso(value)
    def object_value(nil, _), do: "" 
    def object_value(value, _), do: value


    def enc_value(item, type \\ :string)
    def enc_value([first| tail] = item, _), do: "[#{Enum.join(item, ",")}]"
    def enc_value(item, :string), do: "\"" <> item <> "\""
    def enc_value(item, :object), do: "{" <> item <> "}"

    # Combines left and right string parts, takes only strings
    def combine(right, left, type \\ :csv)
    def combine(right, "", :csv), do: right
    def combine(right, left, :csv), do: left <> "\n" <> right

    def combine(right, "", :json), do: right
    def combine(right, left, :json), do: left <> "," <> right

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