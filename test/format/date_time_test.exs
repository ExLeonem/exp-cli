defmodule TestExpFormatDateTime do
    use ExUnit.Case
    alias Exp.Format.DateTime, as: ExpDateTime

    @doctest ExpDateTime


    test "test &now/0" do
        date_time = ExpDateTime.now()
        assert !is_nil(date_time)
    end

    describe "test &diff/2" do
        
        test "valid" do
            first_date = ExpDateTime.now()
            second_date = ExpDateTime.now()
            diff = ExpDateTime.diff(second_date, first_date)
            assert is_integer(diff) == true
        end

        test "invalid/first-argument/wrong-type" do
            date_time = ExpDateTime.now()
            assert_raise FunctionClauseError, fn ->
                ExpDateTime.diff(22, date_time)
            end
        end

        test "invalid/second-argument/wrong-type" do
            date_time = ExpDateTime.now()
            assert_raise FunctionClauseError, fn ->
                ExpDateTime.diff(date_time, 22)
            end
        end

    end


    describe "test &to_iso/1" do
        
        test "valid" do
            iso? = ExpDateTime.to_iso(ExpDateTime.now())
            date_time = ExpDateTime.from_iso(iso?)
            assert is_binary(iso?) && ExpDateTime.valid?(date_time)
        end

        test "invalid/nil" do
            assert_raise FunctionClauseError, fn ->
                ExpDateTime.to_iso(nil) == false
            end
        end

        test "invalid/wrong-type" do
            assert_raise FunctionClauseError, fn ->
                ExpDateTime.to_iso(22) == false
            end
        end

    end

    describe "test &from_iso/1" do
        
        test "valid" do
            date_time_iso = ExpDateTime.now() |> ExpDateTime.to_iso
            assert ExpDateTime.from_iso(date_time_iso)
        end

        test "invalid/empty-string" do
            assert_raise ArgumentError, fn ->
                ExpDateTime.from_iso("")
            end
        end

        test "invalid/nil" do
            assert_raise ArgumentError, fn ->
                ExpDateTime.from_iso(nil)
            end
        end

        test "invalid/wrong-type" do
            assert_raise ArgumentError, fn ->
                ExpDateTime.from_iso(22) 
            end
        end

    end


    describe "test &from_string/1" do

        test "to_date/valid" do
            assert {:ok, _} = ExpDateTime.from_string("22-10-2019")
        end

        test "to_date/invalid-date" do
            assert {:error, _} = ExpDateTime.from_string("33-10-2019")
        end

        test "to_date/invalid-negative" do
            assert {:error, _} = ExpDateTime.from_string("10-10--2020")
        end

        test "to_date/invalid-wrong-format" do
            assert {:error, _} = ExpDateTime.from_string("40.22.2020")
        end

        test "to_date/invalid-type/boolean" do
            assert {:error, _} = ExpDateTime.from_string(true)
        end

        test "to_time/valid" do
            assert {:ok, _} = ExpDateTime.from_string("22:10")
        end

        test "to_time/valid+sec" do
            assert {:ok, _} = ExpDateTime.from_string("22:10:02")
        end

        test "to_time/invalid-wrong-format" do
            assert {:error, _} = ExpDateTime.from_string("11.20")
        end

        test "to_time/invalid-time" do
            assert {:error, _} = ExpDateTime.from_string("11:2k")
        end

        test "to_time/wrong-type/integer" do
            assert {:error, _} = ExpDateTime.from_string(22)
        end    

    end


    describe "test &date_string/1" do
        
        test "valid" do
            today = NaiveDateTime.utc_now()
            assert ExpDateTime.date_string(today) == "#{today.year}-#{today.month}-#{today.day}"
        end

        test "invalid/wrong-type" do
            assert_raise ArgumentError, fn ->
                ExpDateTime.date_string(22)
            end
        end

    end

    describe "test &time_string/1" do
        
        test "valid" do
            now = ExpDateTime.now()
            assert ExpDateTime.time_string(ExpDateTime.now()) == "#{now.hour}:#{now.minute}:#{now.second}"
        end

        test "invalid/wrong-type" do
            assert_raise ArgumentError, fn ->
                ExpDateTime.time_string(22)
            end
        end

    end

end