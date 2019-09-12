defmodule Exp.Args.State do
  require Logger
  alias Exp.Action.State
  alias Exp.Format.Config
  alias Exp.Format.Msgs

  @moduledoc """

  """

  # OptionParser options
  @strict Application.get_env(:exp, :params, [])


  @usage_set """
    Invalid use of exp set

    For information for a specific task use [option] [--help | -h].

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
    result = argv
    |> OptionParser.parse(strict: @strict)
    |> extract_valid
    |> set_config

    case result do
      :ok -> {:ok, "Configuration successfully updated."}
      {:error, _} -> result
      :help -> {:help, @usage_set}
    end
  end

  def set_config({:error, msg} = result), do: result
  def set_config([]), do: :help
  def set_config(argv) do
    State.set_config(argv)
  end



  @usage_get """

    Description:

      Returns default configs.

    Usage:

      exp get [flag | flag flag ...]


    Options:

      --block-length    - set the default length of a learning unit.
      --is-recording    - is CLI currently recording?
      --remind          - Current time of set timer

    """


  @doc """
    Getting configuration parameters through the cli.
  """
  def parse(:get, argv) do
     strict = Config.extract(:schema) |> Config.set_type(:boolean)

      result = argv
      |> OptionParser.parse(strict: strict)
      |> extract_valid
      |> get_config

      case result do
        {:ok, _} -> 
          {:ok, (elem(result,1) |> Enum.map(&Msgs.to_string/1) |> Enum.join(", "))}
        {:error, _} -> result
        :help -> {:help, @usage_get} 
        _ -> {:error, "Unknown error"}
      end
  end

  def parse(_, argv), do: {:error, "invalid directive", []}

  def get_config({:error, msg} = result), do: result  
  def get_config([]), do: :help
  def get_config(argv) do
    argv
    |> Keyword.keys
    |> Enum.reverse
    |> State.get_config
  end


  # ------------------------------
  # Utility functions
  # ------------------------------

  defp extract_valid({valid_argv, rest, invalid} = result) do
    if Enum.empty?(rest) && Enum.empty?(invalid) do
      valid_argv  
    else
      {:error, :invalid_param}
    end

  end
end
