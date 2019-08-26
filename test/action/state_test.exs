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
    State.flush(@config_table)
    State.flush(@entry_table)
    State.init_config()
    :ok
  end

  def teardown do
    State.flush(@config_table)
    State.flush(@entry_table)
    State.shutdown()
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
    State.write_entry({"hey", "some"})
    assert State.write_entry({"hey", "some"}) == false 
  end

  test "replace-existing-entry/entry-table/valid" do
    assert State.write_entry({"hey", "some"}, :replace) == :ok
  end


  describe "test/config/read-write" do
    # Config 
    test "read-first/valid" do
      assert State.get_config(:block_length) == [block_length: "1:30"]
    end

    test "read-last/valid" do
      assert State.get_config(:default_format) == [default_format: :csv]
    end

    test "negative/mid/invalid" do
      assert State.get_config(:remind) != true
    end

    test "update-value/valid" do
      State.init_config() # reset configuration
      State.put_config(:is_recording, true)
      assert State.get_config(:is_recording) == [is_recording: true]
    end

    test "update-value/persisten" do
      State.init_config() # reset configuration
      State.put_config(:is_recording, true)
      State.shutdown()
      State.start_link()
      assert State.get_config(:is_recording) == [is_recording: true]
      State.flush(:config_store)
      State.flush(:entry_store)
      State.shutdown()
    end

  end
  

end
