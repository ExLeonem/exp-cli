defmodule TestExpCli do
  use ExUnit.Case
  doctest Exp.CLI

  # Top level test only test if valid or invalid

  # # No recording process active, valid
  # test "start record valid" do

  # end

  # # recording process already running
  # test "start record invalid" do

  # end


  # test "to many parameters" do

  # end

  # # needs to throw an error
  # test "stop record without recording" do

  # end

end
