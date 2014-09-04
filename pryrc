#
# .pryrc (2014-9-4)
#

# Requires
%w(
cgi/util
date
digest
fileutils
pp
prime
thread
).each do |lib|
  begin
    require lib
  rescue LoadError => e
    puts e.message
  end
end

# Configure
Pry.config.history.should_save = false

# Banner
puts "ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"

