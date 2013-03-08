class redelinux::desktop::mozilla
{
    include redelinux::apt
    
    if $redelinux::params::debian_pre_wheezy {      
        apt::source { 'mozilla':
            location    => 'http://mozilla.debian.net',
            repos       => 'main',
            release     => 'experimental',
            include_src => true,
        }
    } else {
        apt::source { 'mozilla':
            location          => 'http://mozilla.debian.net',
            repos             => 'squeeze-backports',
            release           => 'iceweasel-release',
            required_packages => 'pkg-mozilla-archive-keyring',
            include_src => true,
        }      
    }
        
    package { ['iceweasel', 'icedove']:
        ensure  => latest,
        require => Apt::Source['mozilla']
    } 
}