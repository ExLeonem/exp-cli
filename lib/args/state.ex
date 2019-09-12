defmodule Exp.Args.State do
  require Logger
  alias Exp.Action.State
  alias Exp.Format.Config
  alias Exp.Format.Msgs

  @moduledoc """

  """

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

  @doc """
    Setting configuration parameters through the cli.
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
      -- version        - Get the current cli version
      
    """


  @doc """
    Getting configuration parameters through the cli.
  """
  def parse(:get, argv) do
     strict = Config.extract(:schema) |> Config.set_type(:boolean) |> Keyword.put_new(:help, :boolean)

      result = argv
      |> OptionParser.parse([strict: strict, aliases: [h: :help]])
      |> extract_valid
      |> get_config

      case result do
        {:ok, _} -> {:ok, (elem(result,1) |> Enum.map(&Msgs.to_string/1) |> Enum.join(", "))}
        {:error, _} -> result
        :help -> {:help, @usage_get} 
      end
  end

  def parse(_, argv), do: {:error, "invalid directive", []}

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
end
