defmodule Exp.Args.File do
    require Logger
    alias Exp.Action.File

    @usage_write """

        ---------------------------------------------
        /////////////////// write /////////////////// 
        --------------------------------------------

        Description:

            Writes recorded data to the filesystem. Extracts all information from the given path.
            Possible file extensions are [csv | json | yaml | xml].

        Usage:

            exp write -o /home/<user>/Desktop/test.csv

        Options:

            --output, -o    - Full path includes file name and extension.
            --flush, -f     - Flushes the DETS Tables
        
    
    """

    # Add flag: --new --> only write new data till last write
    @help_config [strict: [help: :boolean], aliases: [h: :help]]
    @parser_config [strict: [output: :string], aliases: [o: :output]]
    
    def parse(:write, argv) do
    
        {valid, rest, invalid} =  argv |> OptionParser.parse(@help_config)

        if valid[:help] do
            {:help, @usage_write}
        else    
            ["--output" | rest] 
                |> OptionParser.parse(@parser_config) 
                |> get_args
                |> File.write
        end
    end
    
    
    def get_args(argv, return_rest \\ false)
    def get_args({[],[],[]}, _), do: {:error, "You passed an insufficient amount of parameter to the command. Need help? Just type exp write -h"}
    def get_args({argv, [], []}, _), do: {:ok, argv}
    def get_args({_, rest, _}, true), do: {:ok, rest}
    def get_args({_, _rest, []}, _), do: {:error, "You passed some unneseccary parameters. Type exp write -h to get information about the usage."}
    def get_args({_, _, _invalid}, _), do: {:error, "You used invalid arguments. Type exp write -h to get information about the usage."}

end