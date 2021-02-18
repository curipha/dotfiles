# ===============
#  .irbrc
# ===============

# Requires
%w(
irb/completion
pp
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
IRB.conf[:INSPECT_MODE] = :pp

# Alias
alias x exit

# Banner
puts RUBY_DESCRIPTION
