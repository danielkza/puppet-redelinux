require 'puppet'

class String
	def rchomp(sep = $/)
    	self.start_with?(sep) ? self[sep.size..-1] : self
  	end
end

module Puppet::Parser::Functions
    newfunction(:module_file_url, :type => :rvalue) do |args|
        return "puppet:///modules/" + lookupvar('caller_module_name') + "/" + args[0].rchomp("/") 
    end
end
