defmodule Exp.Action.File do
    alias Exp.Format.FileOutput
    alias Exp.Action.State
    alias Exp.Format.Config

    @moduledoc """
        Export of saved entries into a specific format.

    """

    @field_names Config.extract(:keys, :field)
    @default_opts [
        name: "exp_data",
        dir: File.cwd(),
        format: :csv
    ]

    @doc """
        Write File in a specific format to the Filesystem.

        Argv-Parameters:
        - format: Fileformat [:csv | :json | :xml]
        - dir: Additional options to set
        - name: The name of the file
        - output: full path to the output directory and filename with extension

    """
    def write({status, _} = input) when status == :error or status == :help, do: input # return {:error, _} | {:help, @usage} 
    def write({:ok, argv}) do
        result = argv |> build_filepath
        data = State.get_entries()
        
        case path do
            {:ok, path, type} -> FileOutput.format(type, data) |> write_out(path)
            {:error, _} -> result
        end

    end

    

    @doc """
        Writes data out to a file.

    """
    def write_out(content, path) do
        
    end


    @doc """
        Builds a full fetched filepath out of OptionParser argv.

        Parameters:
        - argv: OptionParser Arguments 
            - output: full featured output path
            - name: Filename
            - dir: directory path
            - 

        Returns {:ok, path} | {:error, reason}
    """
    def build_filepath(write_opts) do
        
        if Keyword.has_key?(write_opts, :output)  do
            output_path = write_opts[:output]

            if File.exists?(output_path) && !File.dir?(output_path) do
                ext = Path.extname(output_path) |> String.downcase |> String.slice(1..-1) |> String.to_atom
            else

            end 

        else

        end

    end

    def check_full_path(path) do
        
    end



    # def exists?(config) do
        
    # end

    # ----------------------------
    # Utilities

    @doc """
        Check wether file/directory exists
    """
    def exists?(config) do
        {name, dir, format} = config |> Keyword.values |> List.to_tuple
        full_name = get_file_name(name, format)
        full_path = Path.join([dir, full_name])

        if File.exists?(dir) && File.dir?(dir) do
            {true, full_path}
        else
            # Create path that does not exist 
            result = File.mkdir(dir)

            case result do
                :ok -> {true, full_path}
                {:error, :eacces} -> {false, "Couldn't write directory because of lacking permission."}
                {:error, :eexist} -> {false, "Couldn't create Directory. There's already a directory named that way."}
                {:error, :enoent} -> {false, "Couldn't create Directory. A component of the path does not exist."}
                {:error, :enospc} -> {false, "Couldn't create Directory. There's no space left on the device."}
                {:error, :enotdir} -> {false, "Couldn't create Directory. A component of the path is not a directory."}
            end
            
        end

    end

    # Create the file pass result
    def create({true, full_path}), do: full_path |> File.open([:write, :append])
    def create({false, msg} = result), do: {:error, msg}
        
    @doc """

    """
    def fill({:error, msg} = result), do: result
    def fill() do
        
    end


    @doc """
        In either case returns a tuple with default configuration.

        Returns Tuple {:ok {filename, path}} | {:error, "passed parameter doesen't exist."}
    """
    def get_write_config(opts) do
        
    end


    def get_file_name(name, format) when (is_atom(format) or is_binary(format)) and is_binary(name) do
        ext = format |> to_string
        "#{name}.#{ext}"
    end
    def get_file_name(name, format), do: raise ArgumentError, message: "Error in function &get_file_name/2. Expected parameters of type atom and string. Got something else."

end