# ===============
#  .pryrc
# ===============

# Requires
%w(
cgi/util
date
digest
fileutils
pathname
pp
prime
securerandom
shellwords
thread
time
).each do |lib|
  begin
    require lib
  rescue LoadError => e
    puts e.message
  end
end

# Configure
Pry.config.history.should_save = false

# Methods
def req(lib)
  puts "require '#{lib.to_s}'"
  require(lib.to_s)
end

# Alias
alias q exit
alias x exit

# Banner
puts RUBY_DESCRIPTION


# vim: filetype=ruby
