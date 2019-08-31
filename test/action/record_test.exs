defmodule TestExpActionRecord do
  use ExUnit.Case
  alias Exp.Action.Record
  alias Exp.Action.State
  doctest Exp.Action.Record

  defmodule FakeIO do
      def gets(param), do: param
  end

  def teardown() do
    State.flush(:config_store)
    State.flush(:entry_store)
    State.shutdown()
  end


  test "start/valid/no_timer/no_remind" do
    State.start_link()
    assert  {:ok, _} = Record.start({[],[],[]})
    teardown()
  end

  test "stop/invalid/not-recording" do
    State.start_link()
    assert {:error, _} = Record.stop(FakeIO)
    teardown()
  end

  test "stop/valid/default" do
    State.start_link()
    Record.start({[],[],[]})
    assert {:ok, _} = Record.stop(FakeIO)
    teardown()
  end

  @tag timeout: 200
  test "user_request_param" do
    checker = fn value -> is_binary(value) end
    assert Record.request_user_argument("2", checker, FakeIO) == "2"
  end

  test "request_user_argument/invalid" do
    assert_raise ArgumentError, fn ->
      Record.request_user_argument("Hey", 2)
    end
  end

  test "parse_remind/valid/22:22" do
    assert  Record.parse_remind("22:22") == [hours: 22, minutes: 22]
  end

  test "parse_remind/cut_off/22:22:21" do
    assert Record.parse_remind("22:22:1") == [hours: 22, minutes: 22]
  end

  test "parse_remind/invalid/hello" do
    assert {:error, _} = Record.parse_remind("hello")
  end

  test "parse_remind/invalid/22.2:15" do
    assert {:error, _} = Record.parse_remind("22.2:15")
  end

  test "parse_remind/invalid/empty" do
    assert {:error, _} = Record.parse_remind("") 
  end

end
