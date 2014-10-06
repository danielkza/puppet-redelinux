require 'puppet'

Puppet::Parser::Functions.newfunction(:file_exists, :type => :rvalue,
  :arity => 1) \
do |args|
  Puppet::FileSystem.exists?(args[0])
end
