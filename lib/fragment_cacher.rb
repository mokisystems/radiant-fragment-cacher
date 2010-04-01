module FragmentCacher
  include Radiant::Taggable

  class TagError < StandardError; end

  def read_metadata(path)
    name = "#{path}.yml"
    if File.exists?(name) and not File.directory?(name)
      content = File.open(name, "rb") { |f| f.read }
      metadata = YAML::load(content)
      metadata if metadata['expires'] >= Time.now
    end
  rescue
    nil
  end

  desc %{
    Caches a block of content for a configurable time period. A unique 'name' is required.
    An optional 'time' may be supplied (in minutes) to specify how long the cache should
    be used for - the default is 30 minutes.

    All cached fragments are expired whenever a Page, Snippet or Layout is saved.
    
    *Usage*:
    
    <pre><code><r:cache name="cache name" [time="30"]>...</r:cache></code></pre>
  }
  tag "cache" do |tag|
    attr = tag.attr.symbolize_keys
    raise TagError.new("`name' paramater must be included") if attr[:name].blank?
    # Default time to 30 minutes
    attr[:time] = attr[:time].to_i
    attr[:time] = 30 if attr[:time].blank? || attr[:time] <= 0
    cache_file = File.join(RAILS_ROOT + "/tmp/fragment_cache", "_fragment_#{attr[:name].tr('.:/\ ','_')}")
    if read_metadata(cache_file)
      # Return the cached version
      return File.open("#{cache_file}.data", "rb") {|f| f.read}
    else
      content = tag.expand
      metadata = { 'expires' => attr[:time].minutes.from_now }.to_yaml
      File.open("#{cache_file}.data", "wb+") { |f| f.write(content) }
      File.open("#{cache_file}.yml", "wb+") { |f| f.write(metadata) }
      return content
    end    
  end

end
