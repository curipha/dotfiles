#
# .irbrc (2014-9-1)
#

# Requires
%w(
date
digest
fileutils
irb/completion
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
IRB.conf[:AUTO_INDENT] = true

# Banner
puts "ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE} patchlevel #{RUBY_PATCHLEVEL}} [#{RUBY_PLATFORM}]"

