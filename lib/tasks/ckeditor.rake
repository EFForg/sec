
Rake::Task["assets:precompile"].enhance do
  Rake::Task["ckeditor:nondigest"].invoke
end
