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
            t: :timeframe
        ],
        strict: [
            all: :boolean,
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
        |> _get_entries
        |> Formatter.format_entries
    end


    def _get_entries({[],[],[]}), do: State.get_entries
    

    
end