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
    def to_iso(date_time), do: NaiveDateTime.to_iso8601(date_time)

    @doc """
        Reads an iso8601 DateTime string into a NaiveDateTime.
    """
    def from_iso(iso_dt_string) when not is_binary(iso_dt_string), do: raise ArgumentError, message: "Error in function &from_iso/1. Expected a string as argument, got something else."
    def from_iso(iso_dt_string) do
        try do
            {:ok, date_time} = NaiveDateTime.from_iso8601(iso_dt_string)
            date_time 
        rescue
            MatchError -> raise ArgumentError, message: "Error in function &from_iso/1.Couldn't parse string #{iso_dt_string} to NaiveDateTime."
        end
    end

    @doc """
        Calculates the difference between to NaiveDateTimes in seconds.
    """
    def diff(naiv_start, naiv_end) do
        NaiveDateTime.diff(naiv_start, naiv_end)
    end

    @doc """
        Formats the given NaiveDateTime to a string representing a date. 

        Parameters:
            - date_time: either NativeDateTime | iso_8601 string

        return string of form 'year-month-day'
    """
    def date_string(date_time) when is_binary(date_time), do: date_time |> from_iso |> date_string
    def date_string(date_time) when not is_binary(date_time) do
        year = date_time.year
        month = date_time.month
        day = date_time.day

        "#{year}-#{month}-#{day}"
    end

    @doc """
        Formats a given NaiveDatetime to a string representing a time.

        Parameters:
            - date_time: either NativeDateTime | iso_8601 string
    """
    def time_string(date_time) when is_binary(date_time), do: date_time |> from_iso |> date_string
    def time_string(date_time) do
        hour = date_time.hour
        minute = date_time.minute
        seconds = date_time.second

        "#{hour}:#{minute}:#{seconds}"
    end

    @doc """
        Takes the a time difference in seconds and returns a string of form `hh:mm:ss` representing a duration

        Parameters:
        - seconds: the time difference

        returns a string representing the duration with HH:MM:SS
    """
    def duration(seconds) do
        sec = rem(seconds, 60)
        minutes = if seconds >= 60, do: div(seconds, 60), else: 0
        hours = if minutes > 60, do: div(minutes, 60), else: 0
        real_minutes = minutes - (hours*60)
        "#{hours}:#{real_minutes}:#{sec}"
    end


    @doc """
        Formats the given string to a NaiveDateTime.

        Parameters:
            - date_time_string: string representing the current date/time in form dd-MM-YYYY HH:MM:SS (May consist of both parts or only date/time)
        
        return NaiveDateTime
    """
    # def from_string(date_time_string) when not is_binary(date_time_string), do: {:error, "Error in function &ExpDateTime.from_string/1 exptected a string as input."}
    def from_string(date_time_string) when not is_binary(date_time_string) do
           try do
            {:ok, NaiveDateTime.truncate(date_time_string, :second)}
        rescue
            FunctionClauseError -> {:error,  "Error in function &ExpDateTime.from_string/1 exptected a string as input."} 
        end
    end

    def from_string(date_time_string) do
        try do
            parts = date_time_string |> String.split(" ") 

            case length(parts) do
                1 ->
                    # Either date or time was passed, build NaiveDateTime from them
                    [part] = parts
                    if valid?(part, :date) do
                        erl_date = to_erl(part)
                        NaiveDateTime.from_erl({erl_date, {0,0,0}})
                    else
                        erl_time = to_erl(part, :time)
                        {date, time} = now() |> NaiveDateTime.to_erl
                        NaiveDateTime.from_erl({date, erl_time})
                    end
                2 ->
                    # probably date and time passed. Decide which is which and parse
                    [first_part , second_part] = parts
                    if valid?(first_part) do
                        date = to_erl(first_part)
                        time = to_erl(second_part)
                        NaiveDateTime.from_erl({date, time})
                    else
                        date = to_erl(second_part)
                        time = to_erl(first_part)
                        NaiveDateTime.from_erl({date, time})
                    end

                _ -> raise MatchError
            end

        rescue 
            ArgumentError -> {:error, "Failed to parse string into date format."}
            MatchError -> {:error, "Failed to parse string into date format."}
        end
    end


    defp to_erl(date_time_string, type \\ :date)
    defp to_erl(date_string, :date) do
        date_string |> String.split("-") |> Enum.map(&String.to_integer/1) |> Enum.reverse |> List.to_tuple
    end

    defp to_erl(time_string, :time) do
        result = time_string |> String.split(":") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
        num_values = tuple_size(result)

        case num_values do
            2 -> 
                {hour, minute} = result
                {hour, minute, 0}
            3 -> result
            _ -> raise ArgumentError
        end
    end
    

    @doc """
        Is the passed value a valid date or time according to the used time and date formats within this code.

        Accepted formats:
            - time: hh:mm
            - date: YYYY-MM-dd

        return boolean
    """
    def valid?(value, part \\ :date_time)
    def valid?(value, :date_time), do: if valid?(value, :date) && valid?(value, :time), do: true, else: false 
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
    def valid?(value, :date) do
        try do
            NaiveDateTime.truncate(value, :second)
            true
        rescue
            FunctionClauseError -> false
        end        
    end
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
    def valid?(value, :time) do
        try do
            NaiveDateTime.truncate(value, :second)
            true
        rescue
            FunctionClauseError -> false
        end
    end
    def valid?(_, _), do: false


end