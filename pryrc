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

# Alias
alias q exit
alias x exit

# Banner
puts RUBY_DESCRIPTION

