defmodule Exp.Args.Display do
    require Logger
    alias Exp.Action.Display
    alias Exp.Action.State
    alias Exp.Action.Formatter

    @moduledoc """
        Module handles CLI calls to query/display data from entry store.
    """

    @usage_display """

        --------------------------------------------
        /////////////////// show /////////////////// 
        --------------------------------------------

        Description:

            Display the currently stored entries.

        Usage:

            exp show --last

            exp show 

        Options:

            --all, -a           - Show all stored entries
            --last, -l          - Show the last saved entry
            --timeframe, -t     - Query entries by timeframe

    """

    @options [
        aliases: [
            a: :all,
            l: :last,
            t: :timeframe,
            h: :help
        ],
        strict: [
            all: :boolean,
            last: :boolean,
            timeframe: :string,
            help: :boolean
        ]
    ]
    
    @doc """

    """
    def parse(:show, argv) do
        argv
        |> OptionParser.parse(@options)
        |> get_entries

        #TODO: output needs to be formatted
        # |> Formatter.format_entries
    end


    # TODO: check wether one ore more parameter set and respond to user
    def get_entries({argv, _, _}) do

        if argv[:help] do
            {:help, @usage_display}
        else
            time_frame = argv[:timeframe]
            get_all? = argv[:all]
            last? = argv[:last]
            
            result = cond do
                last? -> _get_entries(:last)
                !is_nil(time_frame) && time_frame != "" -> _get_entries(:timeframe, time_frame)
                true -> _get_entries(:all) 
            end
            format_result(result)
        end
    end 

    def format_result(result, aggregate \\ "")
    def format_result([], ""), do: {:ok , "There's no recorded data yet."}
    def format_result([], aggregate), do: {:ok, aggregate}
    def format_result(result, aggregate) do
        aggregate <> "++++ Result ++++"
        _format_result(result, aggregate)
    end

    def _format_result([], aggregate), do: {:ok, aggregate}
    def _format_result([h| t], aggregate) do
        # Needs to be dynamically generated
        {date_time, start_t, end_t, title, tags, duration} = if is_tuple(h) do
            h 
        else
            [ele] = h
            ele
        end
        title = title |> String.replace("\n", "")
        date = Date.to_string(date_time)
        add_to_output = "\n[#{date}] Duration: #{duration}, Title: #{title}"
        aggregate = aggregate <> add_to_output
        format_result(t, aggregate)
    end

    def _get_entries(type, filter \\ "")
    def _get_entries(:last, _), do: State.get_last_entry()
    def _get_entries(:all, _), do: State.get_entries()
    def _get_entries(:timeframe, timeframe) do
        # Filter entries by timeframe filter
    end
    def _get_entries(type, _), do: raise ArgumentError, message: "Unknown filter type: #{type}"

    
end