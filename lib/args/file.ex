defmodule Exp.Args.File do
    require Logger
    alias Exp.Action.File

    @usage_write """

        Description:

            Exports the saved data to a specific format. Available file-formats are [csv, json, xml, yaml].

        Usage:

                exp write -o ./home/user/Desktop/test_data.csv

                exp write -f yaml -d ./home/user/Desktop

        Parameter:

        --output, -o    - Full fetched output path with filename and file extension. If this options is passed all other options are ignored
        --dir, -d       - To which directory to write to?
        --format, -f    - Output format of the file. [:csv, :json, :yaml, :xml]

    """

    @parser_config [
        alias: [
            o: :output,
            d: :dir,
            f: :format,
            h: :help
        ],
        strict: [
            output: :string,
            dir: :string,
            format: :string,
            help: :boolean
        ]
    ]

    def parse(:write, argv) do
        argv
        |> OptionParser.parse(@parser_config)
        |> get_arguments
        |> preprocess_args
    end


    def preprocess_args({:error, })
    def preprocess_args({:ok, args}) do
        
        if Keyword.has_key?(args, :help) do
            {:help, @usage_write} 
        else

            # Check what is filled in args and should be further used
            cond do
                
            end

        end
    end

    
    @doc """
        Checks the value passed with the -o option.

        Returns tuple in form {:ok, {path, format}} | {:error, reason}
    """
    def extract_path_information(path) do
        extension = Path.extname(path)
        dir_path = Path.dirname(path)

        cond do
            extension != "" && File.dir?(dir_path) -> {:ok, {path, extension}}
            extension == "" -> {:error, can}
        end

    end


    
    def get_args({[],[],[]}), do: {:error, "You passed an insufficient amount of parameter to the command. Need help? Just type exp write -h"}
    def get_args({argv, [], []}), do: {:ok, argv}
    def get_args({_, _rest, []}), do: {:error, "You passed some unneseccary parameters. Type exp write -h to get information about the usage."}
    def get_args({_, _, _invalid}), do: {:error, "You used invalid arguments. Type exp write -h to get information about the usage."}

end