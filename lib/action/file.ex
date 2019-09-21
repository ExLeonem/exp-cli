defmodule Exp.Action.File do
    require Logger

    alias Exp.Format.FileOutput
    alias Exp.Action.State
    alias Exp.Format.Config
    alias Exp.Format.CLI

    @moduledoc """
        Export of saved entries into a specific format.

    """

    @field_names Config.extract(:keys, :field)
    @valid_extensions [:csv, :json, :yaml, :xml]


    @doc """
        Write files in a specific format to the filesystem.
        Valid formats include csv, json, xml and yaml.

        Argv-Parameters:
        - flush: cleans the dets store after a successful write
        - output: full path to the output directory and filename with extension


        returns {:error, reason} | {:help, message} | {:ok, message}
    """
    def write({status, _} = result) when status == :error or status == :help, do: result # return {:error, _} | {:help, @usage} 
    def write({:ok, argv}) do
        
        # TODO: Check if there is content at all to write.
        # Modify Agent to only need read once. --> save content inside state
        {is_valid?, result} = argv |> path_valid? 

        if is_valid? do
            {full_path, type} = result
            data = State.get_entries

            type
            |> FileOutput.format(data)
            |> create(full_path)
            |> fill

        else
            {:error, result}
        end
    end


    @doc """
        Checks the given path and it's components for validity.
        Creates the needed file to write the content.

        Parameters:
            - write_opts :  

        Returns {:ok, path} | {:error, reason}
    """
    def path_valid?(write_opts) do
        
        if Keyword.has_key?(write_opts, :output)  do
            output_path = write_opts[:output]

            # Get the components
            type = output_path |> Path.extname |> String.slice(1..-1) |> String.to_atom 
            dir_path = Path.dirname(output_path)

            if File.dir?(dir_path) do

                case type do
                     ext when ext in @valid_extensions -> {true, {output_path, type}}
                    :"" -> {false, "I couldn't write the file. Seems like you missed the file extension in \"#{output_path}\"."}
                    _ -> {false, "Sorry the file extension \"#{type}\" is currently not supported. Supported formats are [csv, json, xml, yaml]."}

                end                

            else
                {false, "Some part of the path is not existent. Are you sure that this folder structure already exists?"}
            end
            
        else
            {false, "You need at least pass me a path with a valid file name. Check exp write --help to get more info."}
        end

    end

    
    @doc """
        Creates the file to be filled
    """
    def create({status, _} = result, path) when status in [:error, :help], do: result
    def create({:ok, content}, path) do

        opened? = File.open(path, [:write])

        case opened? do
            {:ok, pid} -> {:ok ,{pid, content}}
            {:error, reason} -> reason |> process_fs_error
        end

    end
    def create(not_successfull_format, _path), do: not_successfull_format


    @doc """
        Fills the file with the formatted content

        Parameters:
            - file_pid: PID of the successfully opened file.
            - content to be written to the file

        returns {:ok, msg} | {:error, msg}
    """
    def fill({:error, _} = result), do: result
    def fill({:ok, {file, content}}) do
        written? = IO.write(file, content)

        File.close(file)

        case written? do
            :ok -> CLI.ok("File successfully written.")
            :error -> CLI.error("Couldn't write the file.") 
        end
    end


    # Custom error messages
    def process_fs_error(:eacces), do: {:error, "Missing search or write permission."}
    def process_fs_error(:eexist), do: {:error, "There's already a file named this way."}
    def process_fs_error(:enoent), do: {:error, "A component of the path is missing."}
    def process_fs_error(:enospc), do: {:error, "There's no space left on the device."}
    def process_fs_error(:enotdir), do: {:error, "A component of the path is not a directory."}

end