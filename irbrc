# ===============
#  .irbrc
# ===============

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
IRB.conf[:PROMPT_MODE] = :SIMPLE

# Methods
def pwd
  Dir.pwd
end

def ls(dir = Dir.pwd)
  system("ls #{dir}")
end
def la(dir = Dir.pwd)
  system("ls -AF #{dir}")
end
def ll(dir = Dir.pwd)
  system("ls -l #{dir}")
end
def lla(dir = Dir.pwd)
  system("ls -AFl #{dir}")
end

def cd(dir = File.expand_path('~'))
  unless File.directory?(dir)
    warn "cd: not a directory: #{dir}"
    return
  end
  Dir.chdir(dir)
  Dir.pwd
end

# Alias
alias q exit
alias x exit

# Banner
puts RUBY_DESCRIPTION

