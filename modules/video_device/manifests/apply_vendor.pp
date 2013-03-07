define video_device::apply_vendor(
    $allow_proprietary = true,
    $ensure            = latest
) {
    # Load the vendor class, found out what is the preferred driver to be
    # installed depending on whether proprietary drivers should be accepted,
    # then instantiate the right class, forwaring the ensure parameter.

    $vendor = $title

    if $allow_proprietary {
        $pref_var = 'pref_proprietary'
    } else {
        $pref_var = 'pref_free'
    }
    
    if !defined("video_device::vendor::${vendor}") {
        fail("Invalid driver vendor '{$vendor}'")
    } else {
	    include "video_device::vendor::${vendor}"
	
	    $driver = getvar("video_device::vendor::${vendor}::${pref_var}")
	    
	    if !is_string($driver) {
	        fail("Failed to retrieve preferred driver for vendor ${vendor}. Certify that both pref_proprietary and pref_free are properly set.")
	    } else {
	        if !defined( "video_device::vendor::${vendor}::${driver}") {
	            fail("Invalid driver '${driver}' for vendor '${vendor}'")
	        } else {		      
		        class { "video_device::vendor::${title}::${driver}":
		            ensure => $ensure
		        }
		    }
	    }
	}
}
