require 'pathname'

task :default => [ :tests ]

desc 'Run all tests in path specified (defaults to tests). Tell Rake to start at a specific path with `rake tests[\'tests/lib\']`'
task :tests, :path do |t, args|
  args.with_defaults(:path => 'tests')

  run_recursively = lambda do |dir|
    dir.children.each do |dir_or_test|
      case
      when dir_or_test.directory?                        then run_recursively.call dir_or_test
      when dir_or_test.to_s.match(/_(spec|test)s?\.rb$/) then require_relative dir_or_test
      end
    end
  end

  run_recursively.call Pathname.new(args[:path]).expand_path
end
