defmodule TestPowActionState do
  use ExUnit.Case
  alias Pow.Action.State
  doctest Pow.Action.State

  # test "create default directory/valid" do
  #   assert :ok = State.create_default_config()
  # end

  test "create env/valid" do
    assert :ok = State.create_dir()
  end

  test "get valid key" do
    assert State.get_config(:format) == :csv
  end

  test "set valid key" do
    State.put_config(:format, :json)
    assert State.get_config(:format) == :json
    
    State.put_config(:format, :csv) # reset value
  end

end
