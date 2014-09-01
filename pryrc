#
# .pryrc (2014-9-1)
#

# Requires
%w(
date
digest
fileutils
pathname
pp
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
puts "ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE} patchlevel #{RUBY_PATCHLEVEL}} [#{RUBY_PLATFORM}]"

