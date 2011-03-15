require 'pathname'

require_relative '../boot'

tests_dir = (Pathname.new(__FILE__) + '..' + '..' + 'tests').expand_path
tests_dir.children.each do |test_dir|
  next unless test_dir.directory?
  test_dir.children.each { |test| require test }
end
