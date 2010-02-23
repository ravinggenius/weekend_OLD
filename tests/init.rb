require File.join(File.dirname(__FILE__), '/../boot')

[
  'models'
].each do |test|
  Dir.foreach File.join(File.dirname(__FILE__), test) do |test_case|
    next if File.directory? test_case
    require File.join(File.dirname(__FILE__), test, test_case)
  end
end
