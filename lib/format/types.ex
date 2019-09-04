defmodule Exp.Format.Types do
    require Logger
    alias Exp.Format.Config    
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
    def process_field(:date = key, value, _) do
        {year, month, day} = Date.utc_today |> Date.to_erl
        
        value
        |> filled?(key, default: "#{day}-#{month}-#{year}")
        |> cast(key)
    end

    def process_field(:start = key, value, prev) do

        t_result = value
        |> filled?(key)
        |> cast(:time)

        # Calculate duration if end-time given, else append to prev
        has_end? = not is_nil(prev[:end])
        case t_result do
            {:ok, value} when has_end? -> 
                # End time already set, calculate the time
                {end_time, prev_rest} = Keyword.pop(prev, :end)
                duration = Time.diff(end_time, value) |> format_time_diff
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

    def process_field(:end = key, value, prev) do
        # TODO: duration calculation needs to be fixed. Duration over a day will result in error if end_time < start_time !!
        {hour, minute, _sec} = Time.utc_now |> Time.to_erl 
        
        t_result = value
        |> filled?(key, default: "#{hour}:#{minute}")
        |> cast(:time)

        # Calculate duration if start-time given, else append end-time to prev
        has_start? = not is_nil(prev[:start])
        case t_result do
            {:ok, value} when has_start? ->
                {start_time, prev_rest} = Keyword.pop(prev, :start)
                duration = Time.diff(value, start_time) |> format_time_diff
                new_prev = prev_rest |> Keyword.put(:duration, duration) |> Keyword.put(:end, value)
                {:ok, new_prev}
            {:ok, value} ->
                template = {:end, value}
                new_prev = [template, template | prev]
                {:ok, new_prev}
            {:error, _} -> t_result
        end
    end

    # def process_field(:tag, value, _) do
        
    # end

    def process_field(key, value, _) do
        value
        |> filled?(key)
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
                :date -> string_to_date(value)
                :time -> string_to_time(value)
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
    def valid?(value, :date) when is_binary(value) do
        matches_format = value |> String.match?(~r/[0-9]{1,2}\-[0-9]{1,2}\-[0-9]{4}/)
        if matches_format do
            # Check if values match
            {day, month, year} = value |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple

            cond do
                day == 0 || month == 0 || year == 0 -> false
                month == 2 && ((rem(year, 100) == 0 && rem(year, 400) != 0 && day <= 29) || day <= 28)  -> true
                month <= 7 && ((rem(month, 2) == 0 && day <= 30) ||  (rem(month, 2) != 0 && day <= 31)) -> true 
                month > 7 && ((rem(month, 2) == 0 && day <= 31) || (rem(month, 2) != 0 && day <= 30)) -> true
                true -> false # Alle above checks passed but nothing matched
            end
        else
            false
        end
    end
    def valid?(_, :date), do: false
    def valid?(value, :time) when is_binary(value) do
        matches_format = value |> String.match?(~r/[0-9]{1,2}\:[0-9]{1,2}/)
        if matches_format do
            {hours, minutes} = value |> String.split(":") |> Enum.map(&String.to_integer/1) |> List.to_tuple

            cond do
                hours > 24 || minutes > 59 -> false 
                true -> true
            end
        else
            false
        end
    end
    def valid?(_, :time), do: false
    
    def valid?(_, _), do: raise ArgumentError, message: "Unknown parameter value type: [:string | :boolean | :float | :integer | :date | :time ]"

    # Tries to executed the parsed pipe (which represents a cast from string to a specific type. See in &valid?/2)
    defp try_cast(cast_pipe) do
        try do
            cast_pipe.()
        rescue
            ArgumentError -> false
        end
    end

    # ################################
    #       FORMAT Functions
    # ################################


    @doc """
        Takes the a time difference in seconds and returns a string of form `hh:mm:ss` representing a duration

        Parameters:
        - secs: seconds as integer
    """
    def format_time_diff(secs) do
        # REVIEW: Better way to encode/decode duration? maybe a sigil?
        sec = rem(secs, 60)
        minutes = if secs >= 60, do: div(secs, 60), else: 0
        hours = if minutes > 60, do: div(minutes, 60), else: 0
        real_minutes = minutes - (hours*60)
        "#{hours}:#{real_minutes}:#{sec}"
    end

    @doc """
        Parses a String of form \"dd-MM-YYYY\" into a date

        return {:ok, date} | {:error, msg}
    """
    def string_to_date(date_string) when is_binary(date_string) do
        try do
            {day, month, year} = date_string |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple
            Date.new(year, month, day)
        rescue
            ArgumentError -> {:error, "Error in function &string_to_date/1. Value #{date_string} is in the wrong format. Function expects value to be in dd-MM-YYYY"}
            MatchError -> {:error, "Failed to parse string into date format."}
        end
    end
    def string_to_date(_), do: {:error, "Error in function &string_to_date/1. Wrong parameter type passed. Functions expects value of type string."}

    def date_to_string(date) do
        try do
            {year, month, day} = Date.to_erl(date)
            {:ok, "#{day}-#{month}-#{year}"}
        rescue
            FunctionClauseError -> {:error, "Error in function &date_to_string/1. Expected parameter of type ~D."}
        end
    end

    @doc """
        Parses a string of format \"hh:mm\" into a time.

        return {:ok, time} | {:error, msg}
    """
    def string_to_time(time_string) when is_binary(time_string) do
        try do
            result = time_string |> String.split(":") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
            num_values = tuple_size(result)

            case num_values do
                2 -> 
                    {hour, minute} = result
                    Time.new(hour, minute, 0) 
                3 ->
                    # Logger.debug(time_string)
                    {hour, minute, sec} = result
                    Time.new(hour, minute, sec)
                _ -> raise ArgumentError
            end
        rescue  
            ArgumentError -> {:error, "Error in function &string_to_time/1. Passes parameter has the wrong format. String in format hh:mm:ss or hh:mm expected."}
            MatchError -> {:error, "Error in function &string_to_time/1. Failed to parse string into time format."}
        end
    end
    def string_to_time(_), do: {:error, "Error in function &string_to_time/1. Passed parameter is not of type string."}

    @doc """
        Parses given time into a string.
    """
    def time_to_string(time) do
        try do
            {hour, minute, sec} = Time.to_erl(time)
            {:ok, "#{hour}:#{minute}:#{sec}"}
        rescue
            FunctionClauseError -> {:error, "Error in function &time_to_string/1. Passed parameter is expected to be of type ~T."}
        end
    end


end