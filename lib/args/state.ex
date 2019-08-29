defmodule Pow.Args.State do

  @moduledoc """

  """

  # OptionParser options
  @strict Application.get_env(:pow, :params, [])


  @doc """

  """
  def parse(:set, argv) do
    argv
    |> OptionParser.parse(strict: @strict)
    |> State.set_config()
  end


  def parse(_, argv), do: {:error, "invalid directive", []}

end
