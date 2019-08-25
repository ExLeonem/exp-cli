defmodule TestPowActionRecord do
  use ExUnit.Case
  alias Pow.Action.Record
  doctest Pow.Action.Record

  defmodule FakeIO do
      def gets(param), do: param
  end


  test "start/valid/no_timer/no_remind" do
    assert  {:ok, _} = Record.start([]) 
  end

  # test "start/valid/no_timer/remind" do
    
  # end

  # test "create_entry/valid" do
    
  # end

  test "user_request_param" do
    checker = fn value -> is_integer(value) end
    assert Record.request_user_argument("output", checker, FakeIO) == true
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
