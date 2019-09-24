defmodule Exp.Format.Types do
    require Logger
    alias Exp.Format.Config
    alias Exp.Format.DateTime, as: ExpDateTime

    @moduledoc """
        Utilities to format and generate types
    """

    # All keys are in field_required, because same base and no exclusion of keys
    @field_type Config.extract(:schema, :field)
    @field_required? Config.extract(:required, :field)
    @field_keys Config.extract(:keys, :field)


    @doc """
        Build entries dynamically.

        Returns tuple representing the entry to be written into the store.
    """
    def build_entry({_, rest, invalid}) when rest != [] or invalid != [], do: {:error, "Invalid parameters passed."}
    def build_entry({values, _, _}) do
        iterate_fields(@field_keys, values)
    end

    @doc """
        Iterate over all field keys and build an entry as well as setting default values.

        Parameter:
        - fields: List of field keys as atoms `[:date, :title, :start, ...]` is getting read from config.exs
        - values: The passed values via CLI, as keyword list `[date: "22.10.2019", ...]`
        - acc: Accumulator adding up the values
        - prev: Previously set values to act upon.


        Returns {:ok, values as list} | {:error, reason} 
    """
    
    def iterate_fields(fields, values, acc \\ [], prev \\ [])
    def iterate_fields([], _, acc, []), do: {:ok, acc} # Return the build entry value list
    def iterate_fields([], _, acc, prev) do
        # Prev still contains unused keys, merge values into acc
        acc = acc |> update_entry(prev)
        {:ok, acc}
    end
    def iterate_fields([key| rest], values, acc, prev) do

        try do
            t_result = process_field(key, values[key], prev)

            case t_result do
                {:ok, result} when is_list(result) -> 
                    # t_result returned multiple values (Keyword list)
                    {value, new_prev} = Keyword.pop_first(result, key)
                    iterate_fields(rest, values, [value| acc], new_prev)
                {:ok, value} -> 
                    iterate_fields(rest, values, [value | acc], prev)
                {:error, _} -> 
                    t_result
            end 
        rescue
            e in ArgumentError -> {:error, e.message}
        end

    end

    def update_entry(acc, []), do: acc
    def update_entry(acc, [{key, value}| rest]) do
        # Append new entry if key not already added to acc
        if key not in @field_keys do
            update_entry([value| acc], rest)    
        else
            update_entry(acc, rest)
        end
    end


    @doc """
        Processes a single field.

        May return multiple values, which get append to prev and filled in at the end if not used.
    """
    def process_field(:date = key, value, _), do: {:ok, ExpDateTime.now()} # When was entry written?
    def process_field(:start = key, value, prev) do
        t_result = value
        |> filled?(key)
        |> ExpDateTime.from_string

        # Calculate duration if end-time given, else append to prev
        has_end? = not is_nil(prev[:end])
        case t_result do
            {:ok, value} when has_end? -> 
                # End time already set, calculate the time
                {end_time, prev_rest} = Keyword.pop(prev, :end)
                duration = ExpDateTime.diff(end_time, value) |> ExpDateTime.duration
                new_prev = prev_rest |> Keyword.put(:duration, duration) |> Keyword.put(:start, value)
                {:ok, new_prev}
            {:ok, value} ->
                # End time not set, add :start to prev. Maybe :end will apear later
                template = {:start, value}
                new_prev = [template, template | prev]
                {:ok, new_prev}
            {:error, _} -> 
                t_result
        end   
    end

    def process_field(:tag = key, value, prev) do
        
        t_result = value
        |> filled?(key)

        case t_result do
            {:ok, tags_string} ->

                # Split tag array 
                if is_binary(tags_string) do
                    splitted_values =  tags_string |> String.split(",") |> Enum.map(&String.trim/1) |> List.to_tuple
                    {:ok, splitted_values}
                else
                    if not is_nil(value) do
                        {:error, "Error in function &process_field/3. Passed value is not of type String."}
                    else
                        {:ok, value}
                    end
                end

            {:error, _} -> t_result 
        end
    end

    def process_field(:end = key, value, prev) do
        now = ExpDateTime.now() 
        
        t_result = value
        |> filled?(key, default: ExpDateTime.date_time_string(now))
        |> ExpDateTime.from_string

        # Check value of previously set fields
        has_start? = not is_nil(prev[:start])
        case t_result do
            {:ok, value} when has_start? ->
                # Calculate duration
                {start_time, prev_rest} = Keyword.pop(prev, :start)
                duration = ExpDateTime.diff(value, start_time) |> ExpDateTime.duration
                new_prev = prev_rest |> Keyword.put(:duration, duration) |> Keyword.put(:end, value)
                {:ok, new_prev}
            {:ok, value} ->
                # Append start to check later on and compare
                template = {:end, value}
                new_prev = [template, template | prev]
                {:ok, new_prev}
            {:error, _} -> t_result
        end
    end

    def process_field(key, value, _) do
        # Default just check wether required field was filled
        value |> filled?(key)
    end

    @doc """
        Checks if given field value is empty.

        return true | false depending if field value is empty
    """
    def empty?(value) when value == "" or is_nil(value) or (is_list(value) and value == []) or (is_map(value) and value == %{}) , do: true
    def empty?(_), do: false

    @doc """
       Checks if field is required and filled.

       Parameters:
       - value: the field value
       - key: the field name
       - opts: further options to set
         [
             default: value to set if field not required and no value was given (defaults to `nil`)
         ]    

       returns {:ok, value} | {:error, msg}
    """
    def filled?(value, key, opts \\ [default: nil]) do
        if @field_required?[key] do
            if empty?(value) do
                {:error, "There was no value passed for required field: \"#{key}\"."} 
            else
                {:ok, value}
            end
        else 
            if empty?(value) do
                {:ok, opts[:default]}
            else
                {:ok, value}
            end
        end
    end

    @doc """
        Cast a value to a specific type. Typecheck in the process.

        return {:ok, casted_value} | {:error, msg}
    """
    def cast({:error, msg} = result, _), do: result
    def cast({:ok, value}, type) do
        if valid?(value, type) do
            case type do
                :boolean -> String.to_atom(value)
                :float -> String.to_float(value)
                :integer -> String.to_integer(value)
                :date -> ExpDateTime.from_string(value)
                :time -> ExpDateTime.from_string(value)
                _ -> {:error, "Unknown type \"#{type}\" passed to function &cast/2. Valid values are :boolean, :float, :integer, :date, :time."}
            end
        else
            {:error, "Value can't be casted to #{type}"}
        end
    end

    @doc """
        Checks if the give value is valid depending the given type.

        return true | false
    """
    def valid?(value, type \\ :string)
    def valid?(value, :string), do: is_binary(value)
    def valid?(value, :boolean) when is_binary(value), do: try_cast(fn -> value |> String.to_atom |> is_boolean end)
    def valid?(value, :boolean), do: is_boolean(value)
    def valid?(value, :float) when is_binary(value), do: try_cast(fn -> value |> String.to_float |> is_float end)
    def valid?(value, :float), do: is_float(value)
    def valid?(value, :integer) when is_binary(value), do: try_cast(fn -> value |> String.to_integer |> is_integer end)
    def valid?(value, :integer), do: is_integer(value)
    def valid?(value, :date_time), do: ExpDateTime.valid?(value, :date_time)
    def valid?(value, :date), do: ExpDateTime.valid?(value, :date)
    def valid?(value, :time), do: ExpDateTime.valid?(value, :time)
    def valid?(_, _), do: raise ArgumentError, message: "Unknown parameter value type: [:string | :boolean | :float | :integer | :date | :time ]"

    # Tries to executed the parsed pipe (which represents a cast from string to a specific type. See in &valid?/2)
    defp try_cast(cast_pipe) do
        try do
            cast_pipe.()
        rescue
            ArgumentError -> false
        end
    end

    def to_string(nil), do: "nil"
    def to_string(""), do: "nil"
    def to_string(value) when is_binary(value), do: value
    def to_string(value), do: Kernel.to_string(value)

    
    @info """
        ------------------------------------------
        Format functions
        ------------------------------------------
    """

    @doc """
        Extracts the individual tag values from a string of tags.

    """
    def tags_from_string(tags) when is_nil(tags), do: tags
    def tags_from_string(tags) when is_binary(tags) do
        result = tags 
            |> Enum.split(",") 
            |> Enum.map(&String.trim/1) 
            |> Enum.filter(fn x -> !(is_nil(x) || x == "") end)
        {:ok, result}
    end
    def tags_from_string(_tags), do: {:error, "The given value for Tags is not a string."}

end