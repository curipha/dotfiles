#
# .irbrc (2014-9-14)
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
IRB.conf[:PROMPT_MODE] = :SIMPLE

# Methods
def pwd
  Dir.pwd
end

def ls(dir = Dir.pwd)
  col, margin = 5, 4
  lst, max = [], []

  irbrc_get_direntry(dir).each_slice(col) {|x| lst << x }

  lst.each {|x| x = x.fill('', x.length, col - x.length) if x.length != col }
  lst.transpose.each_with_index {|x, i| max[i] = x.map {|y| y.length }.max + margin }

  lst.each {|x|
    x.each_with_index {|y, i| print y.ljust(max[i]) }
    print "\n"
  }

  return nil
end
def ll(dir = Dir.pwd)
  puts irbrc_get_direntry(dir)
end

def cd(dir = File.expand_path('~'))
  unless File.directory?(dir)
    warn "cd: not a directory: #{dir}"
    return
  end
  Dir.chdir(dir)
  Dir.pwd
end

def irbrc_get_direntry(dir)
  Dir.entries(dir).delete_if {|x| x =~ /^\.+$/ }.sort
    .map {|x|
      case File.ftype("#{dir}/#{x}")
      when 'directory' then x + '/'
      when 'fifo'      then x + '|'
      when 'link'      then x + '@'
      when 'socket'    then x + '='
      else x
      end
    }
end

# Alias
alias q exit
alias x exit

# Banner
puts "ruby #{RUBY_VERSION}p#{RUBY_PATCHLEVEL} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"

