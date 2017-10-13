Spring::Watcher::Listen.class_eval do
  def base_directories
    %w(app config lib spec vendor)
      .uniq.map { |path| Pathname.new(File.join(root, path)) }
  end
end

%w(
  .ruby-version
  .rbenv-vars
  tmp/restart.txt
  tmp/caching-dev.txt
).each { |path| Spring.watch(path) }
