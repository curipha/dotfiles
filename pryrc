# ===============
#  .pryrc
# ===============

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
puts RUBY_DESCRIPTION

