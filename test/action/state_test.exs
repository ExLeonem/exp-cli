defmodule TestPowActionState do
  use ExUnit.Case
  require Logger
  alias Pow.Action.State
  doctest Pow.Action.State

  # test "create default directory/valid" do
  #   assert :ok = State.create_default_config()
  # end

  @config_table :config_store
  @entry_table :entry_store

  @default_config [
    block_length: "1:30", # learning block length
    is_recording: false, # timer is currently recording
    timer: nil,
    remind: nil,
    time_started: nil,
    default_format: :csv # write out format
  ]

  setup do
    State.start_link()
    :ok
  end

  test "init_configuration/valid" do
    assert State.init_config() == :ok
  end

  test "shutdown valid" do
    assert State.shutdown == :ok
  end

  test "read-config-from-table/parameterized/valid" do
    assert State.get_config(:block_length) == [block_length: "1:30"]
  end

  test "read-config-from-table/all/valid" do
    assert Keyword.equal?(State.get_config(), @default_config)
  end

  test "open-dets-tables/config_store/valid" do
    assert :dets.is_dets_file(State.get_table(:config_store))
  end

  test "open-dets-tables/entry_store/valid" do
    assert :dets.is_dets_file(State.get_table(:entry_store))
  end

  test "write-new-entry/entry-table/valid" do
    State.flush(@entry_table)
    assert State.write_entry({"hey", "some"}) == true 
  end

  test "write-new-entry/entry-table/invalid" do
    assert State.write_entry({"hey", "some"}) == false 
  end

  test "replace-existing-entry/entry-table/valid" do
    assert State.write_entry({"hey", "some"}, :replace) == :ok
  end


  describe "read-from-config-store" do
    # Config 
    test "first/valid" do
      assert State.get_config(:block_length) == [block_length: "1:30"]
    end

    test "readlast/valid" do
      assert State.get_config(:default_format) == [default_format: :csv]
    end

    test "negative/mid/invalid" do
      assert State.get_config(:remind) != true
    end
  end
  

end
