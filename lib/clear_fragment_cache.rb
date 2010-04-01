module ClearFragmentCache

  module ClassMethods
    def callbacks
      after_save :clear_fragment_cache
    end
  end

  def clear_fragment_cache
    FileUtils.rm(Dir.glob(RAILS_ROOT + "/tmp/fragment_cache/_fragment_*"))
  end

  def self.included(base)
    base.extend(ClassMethods).callbacks
  end

end