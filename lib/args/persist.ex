defmodule Pow.Args.Persist do
    require Logger

    @options [
        alias: [
            d: :directory,
            f: :format
        ],
        strict: [
            directory: :string,
            format: :string
        ]
    ]

    def parse(:write, argv) do
        argv
        |> OptionParser.parse(@options)
    end
    
end