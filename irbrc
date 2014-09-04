#
# .irbrc (2014-9-4)
#

# Requires
%w(
cgi/util
date
digest
fileutils
irb/completion
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
IRB.conf[:AUTO_INDENT] = true

# Banner
puts "ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"

