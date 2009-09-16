require 'rubygems'
require 'kvs'

KVS.dir = File.dirname(__FILE__) + '/../db'

class Entry
  class <<self
    # create
    def <<(value)
      ts = Time.now
      key = KVS << value.merge({:created_at => ts, :updated_at => ts})
      add_key(key)
      key
    end

    # read
    def [](key)
      KVS[key]
    end

    # update
    def []=(key, value)
      KVS[key] = value.merge({:updated_at => Time.now})
    end

    # delete
    def delete(key)
      KVS.delete(key)
      delete_key(key)
      nil
    end

    def keys
      entry_keys = KVS["entry_keys"]
      unless entry_keys
        entry_keys = []
        KVS["entry_keys"] = entry_keys
      end
      entry_keys
    end

    def add_key(key)
      KVS["entry_keys"] = keys << key
    end

    def delete_key(key)
      entry_keys = keys
      entry_keys.delete(key)
      KVS["entry_keys"] = entry_keys
    end
  end
end
