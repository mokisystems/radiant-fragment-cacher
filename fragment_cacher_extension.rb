class FragmentCacherExtension < Radiant::Extension
  version "0.1"
  description "Allows fragments to be cached outside of the normal Radiant cache."
  url "http://github.com/mokisystems/radiant-fragment-cacher/"
  
  def activate
    cache_dir = ActionController::Base.page_cache_directory
    Dir.mkdir(cache_dir) unless File.exist?(cache_dir)
    Page.send :include, FragmentCacher
  end
  
  def deactivate
  end
end
