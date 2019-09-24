defmodule Exp.Args.State do
  require Logger
  alias Exp.Action.State
  alias Exp.Format.Config
  alias Exp.Format.DateTime, as: ExpDateTime
  alias Exp.Format.Types
  alias Exp.Format.CLI

  @moduledoc """

  """

  @doc """
    Depending on the passed directive, executing different routines.
    Either request the passed time since record starting, get/set configuration parameters or delete entries.


    returns {:ok, msg} | {:error, msg}
  """
  def parse(:status, _) do
    is_recording? = State.get_config(:is_recording)
    
    if is_recording? do
      started_at = State.get_config(:time_started)
      current_duration = ExpDateTime.now()
      |> ExpDateTime.diff(started_at)
      |> ExpDateTime.duration

      {:ok, "Current duration: #{current_duration}"}
    else
      {:error, "You are currently not recording. Start a recording first."}
    end
  end


  @usage_set """

    --------------------------------------------
    /////////////////// set ////////////////////
    --------------------------------------------

    Description:

      Set configuration parameter for the cli.

    Usage:

      exp set [--flag value | --flag value --flag value ...]


    Flags:

      --block-length    - set the default length of a learning unit.
      --remind          - Set the amount of time to pass until reminder should be given.
      --output_format   - the format to write out entries.
    """

  def parse(:set, argv) do
    strict = Config.extract(:schema) |> Keyword.put_new(:help, :boolean)

    result = argv
    |> OptionParser.parse([strict: strict, aliases: [h: :help]])
    |> extract_valid
    |> set_config

    case result do
      :ok -> {:ok, "Configuration successfully updated."}
      {:error, _} -> result
      :help -> {:help, @usage_set}
    end
  end

  def set_config({:error, msg} = result), do: result
  def set_config([]), do: {:error, "You passed no options at all. Type exp set -h for usage information"}
  def set_config(argv) do
    if argv[:help] do
      :help
    else
      State.set_config(argv)
    end
  end



  @usage_get """

    --------------------------------------------
    /////////////////// get /////////////////// 
    --------------------------------------------

    Description:

      Returns default configs.

    Usage:

      exp get [flag | flag flag ...]


    Options:

      --block-length    - set the default length of a learning unit.
      --is-recording    - is CLI currently recording?
      --remind          - Current time of set timer

    """


  def parse(:get, argv) do
     strict = Config.extract(:schema) |> Config.set_type(:boolean) |> Keyword.put_new(:help, :boolean)

      result = argv
      |> OptionParser.parse([strict: strict, aliases: [h: :help]])
      |> extract_valid
      |> get_config

      case result do
        {:ok, _} -> {:ok, (elem(result,1) |> Enum.map(&Types.to_string/1) |> Enum.join(", "))}
        {:error, _} -> result
        :help -> {:help, @usage_get} 
      end
  end

  @doc """
    Get the requested configuration parameter values.

    return {:ok, [values]} | {:error, msg}
  """
  def get_config({status, _} = result) when status in [:help, :error], do: result  
  def get_config([]), do: {:error, "You passed no options at all. Type exp get -h for usage information"}
  def get_config(argv) do
    if argv[:help] do
      :help
    else
      argv
      |> Keyword.keys
      |> Enum.reverse
      |> State.get_config
    end
  end

  @usage_delete """
  
    --------------------------------------------
    /////////////////// delete////////////////// 
    --------------------------------------------

    Description:

        Deletes saved entries.

    Usage:

        exp delete -l

        exp delete -all

    Options:

        --all, -a           - Delete all stored entries
        --last, -l          - Delete the last entry saved
        --filter, -f        - Delete entries by a filter term (cooming soon)

  """

  @delete_types [strict: [last: :boolean, all: :boolean, filter: :string, help: :boolean], aliases: [l: :last, a: :all, f: :filter, h: :help]]
  def parse(:delete, argv) do
    result = argv
    |> OptionParser.parse(@delete_types)
    |> extract_valid
    |> delete_entries
  end

  @doc """
    Delete entries persisted in the dets files.

    returns {:ok, msg} | {:error, msg}
  """
  def delete_entries({:error, _} = result), do: result
  def delete_entries(args) do

    num_entries = length(args)

    if num_entries == 1 do
      cond do
        args[:help] -> {:help, @usage_delete}
        args[:last] -> State.delete_entry(:last)
        args[:all] -> State.delete_entry(:all)
        true -> State.delete_entry(:filter, args[:filter])
      end
    else
      msg = if num_entries > 1, do: "You passed to many arguments. Check exp delete -h for more information.", else: "What do you want me to delete? I need some more arguments. Check exp delete -h"
      {:error, msg}
    end
  end


  # ------------------------------
  # Utility functions
  # ------------------------------

  defp extract_valid({valid_argv, rest, invalid} = result) do
    if Enum.empty?(rest) && Enum.empty?(invalid) do
      valid_argv  
    else
      {:error, "You passed some invalid options. Check the usage with exp get -h"}
    end

  end

  @doc """
    Returns the current CLI version with {:ok, msg}
  """
  def version() do
    version = State.get_config(:version)
    CLI.ok("EXP-CLI version: #{version}", :none)
  end

end
