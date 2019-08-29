defmodule Pow.Args.State do

  alias Pow.Action.State

  @moduledoc """

  """

  # OptionParser options
  @strict Application.get_env(:pow, :params, [])


  @doc """
    Setting configuration parameters through the cli.
  """
  def parse(:set, argv) do
    result = argv
    |> OptionParser.parse(strict: @strict)
    |> extract_valid
    |> State.set_config()

    case result do
      :ok -> {:ok, "Configuration successfully updated."}
      {:err, _} -> result
    end
  end


  @doc """
    Getting configuration parameters through the cli.
  """
  def parse(:get, argv) do
    argv
    |> OptionParser.parse(strict: @strict)
    |> extract_valid
    |> State.get_config_bag()
  end

  def parse(_, argv), do: {:error, "invalid directive", []}


  defp extract_valid({valid_argv, _, _}) do
    valid_argv
  end

end
