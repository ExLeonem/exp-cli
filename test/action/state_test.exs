defmodule TestExpActionState do
  use ExUnit.Case
  require Logger
  alias Exp.Action.State
  alias Exp.Format.Config
  doctest Exp.Action.State

  # test "create default directory/valid" do
  #   assert :ok = State.create_default_config()
  # end

  @config_table :config_store
  @entry_table :entry_store

  @default_config Config.extract(:defaults)

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
    assert State.get_config(:block_length) == "1:30"
  end

  test "read-config-from-table/all/valid" do
    assert Keyword.equal?(State.get_config(), @default_config)
  end

  test "open-dets-tables/config_store/valid" do
    assert :dets.is_dets_file(State.get_table(:config_store))
  end

  test "open-dets-tables/entry_store/valid" do
    # Error here
    assert :dets.is_dets_file(State.get_table(:entry_store))
  end


  describe "test/entry/read-write" do
    
    test "write-new-entry/entry-table/valid" do
      State.flush(@entry_table)
      assert State.write_entry({"hey", "some"}) == true 
      teardown()
    end

    test "write-new-entry/entry-table/invalid" do
      # Erorred one time
      State.write_entry({"hey", "some"})
      assert State.write_entry({"hey", "some"}) == false 
      teardown()
    end

    test "replace-existing-entry/entry-table/valid" do
      assert State.write_entry({"hey", "some"}, :replace) == :ok
      teardown()
    end

    test "entries read" do
      State.write_entry({Time.utc_now(), "hey"})
      State.write_entry({Time.utc_now(), "bonjour"})
      assert State.get_entries() != []
      teardown()
    end

    
  end


  describe "test/config/read-write" do

    test "read-last/valid" do
      assert State.get_config(:output_format) == :csv
    end

    test "negative/mid/invalid" do
      assert State.get_config(:remind) != true
    end

    test "update-value/valid" do
      State.init_config() # reset configuration
      State.put_config(:is_recording, true)
      assert State.get_config(:is_recording) == true
      teardown()
    end

    test "update-value/persisten" do
      State.init_config() # reset configuration
      State.put_config(:is_recording, true)
      State.shutdown()
      State.start_link()
      assert State.get_config(:is_recording) == true
      teardown()
    end

    test "update-value/las_entry" do
      State.init_config()
      now = Time.utc_now()
      State.put_config(:last_entry, now)
      last_entry = State.get_config(:last_entry)
      assert last_entry == now
      teardown()
    end

    test "set-config/persist" do
      State.init_config()
      update_keys = [block_length: "2:00", remind: true]
      State.set_config(update_keys)
      assert State.get_config(:block_length) == "2:00"
      assert State.get_config(:remind) == true
      teardown()
    end

  end
  
end
