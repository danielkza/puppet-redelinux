# Based on puppet-module-nvidia by pdxcat:
# https://github.com/pdxcat/puppet-module-nvidia
# License: Apache 2.0

video_vendors = Hash[
    "amd"    => /(Advanced Micro Devices|ATI Technologies Inc)/i,
    "nvidia" => /NVIDIA/i,
    "intel"  => /Intel Corporation/i
]

command = %q{lspci -mm | sed -n 's/^[0-9:. ]*"VGA compatible controller" //p'}
lspci_out = (Facter::Util::Resolution.exec(command) or '')
        
vendor_devices = Hash.new{|hash, key| hash[key] = []}
lspci_out.each_line do |line|
    match = /^"([^"]*)" "([^"]*)"/.match(line)
             
    video_vendors.each do |vendor, pattern|
        if match[1] =~ pattern
            vendor_devices[vendor] << match[2]
        end
    end
end

Facter.add(:video_device_vendors) do
    confine :kernel => :linux
    setcode do
        vendor_devices.keys.join(' ')
    end
end

vendor_devices.each do |vendor, devices|
    devices.each_with_index do |device, index|
        Facter.add("video_device_#{vendor}_#{index}") do
            confine :kernel => :linux
            setcode do
                device
            end
        end
    end
end
