module HasMongoMeta
 def self.included(base)  
   base.send :extend, ClassMethods 
 end  
 
 module ClassMethods 
   def has_mongo_meta(options = {})
     send :include, InstanceMethods
     send :after_save, :save_meta_data
   end
  end
  
  module InstanceMethods
    
    def save_meta_data
      if @metadata
        @metadata._active_record_id = self.id
        @metadata._active_record_type = self.class.to_s
        @metadata.save
      end
    end
    
    def metadata
      @metadata ||= get_metadata
    end
    
    def metadata=(meta_data)
      if @metadata
        @metadata.attributes = meta_data
      else
        @metadata = set_metadata(meta_data)
      end
    end
    
    def method_missing(method, *args)
      if metadata.respond_to? method
        metadata.send(method)
      else
        super
      end
    end
    
    private
    
    def get_metadata
      if self.new_record?
        ActiveMongoMeta.new
      else
        find_meta_data || ActiveMongoMeta.new
      end
    end
    
    def set_metadata(args)
      if self.new_record?
         ActiveMongoMeta.new(args)
      else
        find_meta_data.atrributes = args || new_metadata(args)
      end
    end
    
    def find_meta_data
      ActiveMongoMeta.first({:_active_record_id => self.id, :_active_record_type => self.class.to_s})
    end
    
  end 
end 

ActiveRecord::Base.send :include, HasMongoMeta 