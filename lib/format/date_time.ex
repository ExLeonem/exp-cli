defmodule Exp.Format.DateTime do
    @moduledoc """
        Definition of functions to be used on time operations.
        Based on elixir NaiveDateTime and Erlang :calendar Modules.
    """

    @doc """
        Returns the current local time. Based on device time.
    """
    def now() do
        erl_date_time = :calendar.local_time
        {:ok, date_time} = NaiveDateTime.from_erl(erl_date_time)
        date_time
    end

    @doc """
        Converts the given NaiveDateTime to an iso8601 string.
    """
    def to_string(date_time) do
        NaiveDateTime.to_iso8601(date_time)
    end

    @doc """
        Reads an iso8601 DateTime string into a NaiveDateTime.
    """
    def from_string(iso_dt_string) do
        {:ok, date_time} = NaiveDateTime.from_iso8601(iso_dt_string)
    end

    @doc """
        Calculates the difference between to NaiveDateTimes in seconds.
    """
    def diff(naiv_start, naiv_end) do
        NaiveDate.diff(naiv_start, naiv_end)
    end

    @doc """
        Formats the given NaiveDateTime to a string representing a date. 
    """
    def date_string(date_time) do
        
    end

    @doc """
        Formats a given NaiveDatetime to a string representing a time.
    """
    def time_string(date_time) do
        
    end

    @doc """
        Formats a given NaiveDateTime to a string representing a duration.
    """
    def duration_string(date_time) do
        
    end

    


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

    def string_to_date(value) do
        try do
            {:ok, DateTime.truncate(value, :second)}
        rescue
            FunctionClauseError -> {:error, "Error in function &string_to_date/1. Wrong parameter type passed. Functions expects value of type string or datetime."} 
        end
    end

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

            # {zone, result} = System.cmd("date", ["+%Z"])
            # dt = %DateTime{year: , month: , day: , hour: , minute: , second: , }

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
    def string_to_time(value) do
        try do
            {:ok, DateTime.truncate(value, :second)}            
        rescue
            FunctionClauseError -> {:error, "Error in function &string_to_time/1. Passed parameter is not of type string."}
        end
    end

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

    def get_current_time() do
        
    end


end