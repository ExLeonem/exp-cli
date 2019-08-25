defmodule TestPowActionState do
  use ExUnit.Case
  alias Pow.Action.State
  doctest Pow.Action.State

  test "create default directory/valid" do
    assert :ok = State.create_default_config()
  end

  test "create env/valid" do
    assert :ok = State.create_directory(Path.join([System.user_home(), "Desktop", "PowTimer"]))
  end

  test "load config" do
    assert {:ok, %{"format" => "csv", "chunk_size" => "1:30"}} =  State.load_config(Path.join([System.user_home(), "Desktop", "PowTimer"]))
  end

end
