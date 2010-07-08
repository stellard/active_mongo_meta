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
      @metadata.save if @metadata
    end
    
    def metadata
      @metadata ||= get_metadata
    end
    
    def metadata=(meta_data)
      # debugger
      metadata.attributes = metadata.attributes.merge!(meta_data)
    end
    
    def method_missing(*args)
      raise
      debugger
    end
    
    private
    
    def get_metadata
      if self.new_record?
        new_metadata
      else
        ActiveMongoMeta.find({:_active_record_id => self.id, :_active_record_type => self.class.to_s}) || new_metadata  
      end
    end
    
    def new_metadata
      ActiveMongoMeta.new :_active_record_id => self.id, :_active_record_type => self.class.to_s
    end
    
  end 
end 

ActiveRecord::Base.send :include, HasMongoMeta 