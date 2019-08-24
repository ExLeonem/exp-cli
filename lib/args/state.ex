defmodule Pow.Args.State do

  @moduledoc """

  """


  # OptionParser options
  @params []
  @aliases []
  @strict []


  @doc """


  """
  def parse(:set, argv) do

  end

  def parse(:show, argv) do
    # argv
    # |> OptionParser.parse([])
  end

  def parse(_, argv), do: {:error, "invalid directive", []}


  defmodule Pow.Args.State.Show do

  end

end
