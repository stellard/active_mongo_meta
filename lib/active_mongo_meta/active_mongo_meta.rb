class ActiveMongoMeta
  include MongoMapper::Document

  key :_active_record_id, Integer
  key :_active_record_type, String
  key :_keys, Array #TODO check for uniq
  key :_data, Hash
    
  def attributes=(attribs)
    debugger
    attribs["_data"] ||= {}
    attribs["_data"].merge!(filter_meta_data(attribs))
    super
    for key in self._keys
      create_accessor(key)
    end
    debugger
  end

  def define_datum(key, value = nil)
    add_datum key, value
    create_accessor(key)
  end
  
  def _data=(metadata)
    if metadata.is_a? Hash
      self["_data"].merge!(metadata)
      add_keys metadata.keys
    end
  end
  
  def metadata
    self._data
  end
  
  private
  
  def filter_meta_data(init_attr)
    #ensures keys are always a string when they are compared to the attributes
    init_attr.each do |k,v|
      if k.is_a? Symbol
        init_attr[k.to_s] = v
        init_attr.delete(k)
      end
    end
    meta_data_keys = init_attr.keys - self.attributes.keys
    meta_data = {}
    meta_data_keys.each { |key| meta_data.merge!({key => init_attr.delete(key)}) }
    meta_data 
  end
  
  def add_keys keys
    if keys.is_a? Array
      (self._keys += keys.map(&:to_s)).uniq!
    else
      (self._keys << keys.to_s).uniq!
    end
  end
  
  def add_datum key, value
    add_keys key
    metadata[key.to_s] = value
  end
  
  def create_accessor(key)
    self.class_eval(
      "def #{key} 
        self._data['#{key}']
      end")
    self.class_eval(
      "def #{key}=(value)
        self._data['#{key}'] = value
      end")
  end
  
end