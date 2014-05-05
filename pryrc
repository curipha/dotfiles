#
# .pryrc (2013-3-4)
#

# Banner
puts "ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE} patchlevel #{RUBY_PATCHLEVEL}} [#{RUBY_PLATFORM}]"

# Requires
#%w(
#
#).each do |lib|
#  begin
#    require lib
#  rescue LoadError => e
#    puts e.message
#  end
#end

# Configure
Pry.config.history.should_save = false

