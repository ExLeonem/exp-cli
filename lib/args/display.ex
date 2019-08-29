defmodule Pow.Args.Display do
    require Logger
    alias Pow.Action.Display
    alias Pow.Action.State
    alias Pow.Action.Formatter


    @get_strict [

    ]

    def parse(:get, argv) do
        {:ok, ""}
    end


    @options [
        aliases: [
            a: :all,
            l: :last,
            t: :timeframe
        ],
        strict: [
            all: :boolean,
            last: :boolean,
            timeframe: :string
        ]
    ]

    # @show_strict [
        
    # ]

    @doc """

    """
    def parse(:show, argv) do
        argv
        |> OptionParser.parse(@options)
        |> get_entries
        |> Formatter.format_entries
    end


    # TODO: check wether one ore more parameter set and respond to user
    def get_entries({argv, _, _}) do
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

    def format_result(result, aggregate \\ "")
    def format_result([], ""), do: {:ok , "There's no recorded data yet."}
    def format_result([], aggregate), do: {:ok, aggregate}
    def format_result(result, aggregate) do
        aggregate <> "++++ Result ++++"
        _format_result(result, aggregate)
    end

    def _format_result([], aggregate), do: {:ok, aggregate}
    def _format_result([h| t], aggregate) do
        {date_time, duration, title} = if is_tuple(h) do
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
        
    end
    def _get_entries(type, _), do: raise ArgumentError, message: "Unknown filter type: #{type}"

    
end