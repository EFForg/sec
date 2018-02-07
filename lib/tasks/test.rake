
desc "Run all tests (rspec, rubocop, sass-lint)"
task :test do
  [
    system("node_modules/.bin/sass-lint -vq"),
    system("bundle exec rubocop"),
    system("bundle exec rspec")
  ].all?
end
