require 'puppet'

class String
  def rchomp(sep = $/)
    start_with?(sep) ? self[sep.size..-1] : self
  end
end

Puppet::Parser::Functions.newfunction(:module_file_url, :type => :rvalue) do |args|
  return "puppet:///modules/" + lookupvar('caller_module_name') + "/" + args[0].rchomp("/") 
end
