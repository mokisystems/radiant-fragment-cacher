class FragmentCacherExtension < Radiant::Extension
  version "0.2"
  description "Allows fragments to be cached outside of the normal Radiant cache."
  url "http://github.com/mokisystems/radiant-fragment-cacher/"
  
  def activate
    cache_dir = RAILS_ROOT + "/tmp/fragment_cache"
    Dir.mkdir(cache_dir) unless File.exist?(cache_dir)
    Page.send :include, FragmentCacher

    Page.class_eval do
      include ClearFragmentCache
    end
    Snippet.class_eval do
      include ClearFragmentCache
    end
    Layout.class_eval do
      include ClearFragmentCache
    end
  end
  
  def deactivate
  end
end
