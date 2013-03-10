class redelinux::desktop::mozilla
{
    include redelinux::params
    require redelinux::apt
    
    if !$redelinux::params::debian_pre_wheezy {      
        apt::source { 'mozilla':
            location    => 'http://mozilla.debian.net',
            repos       => 'main',
            release     => 'experimental',
            include_src => true,
        }
    } else {
        apt::source { 'mozilla':
            location          => 'http://mozilla.debian.net',
            repos             => 'iceweasel-release',
            release           => 'squeeze-backports',
            required_packages => 'pkg-mozilla-archive-keyring',
            include_src => true,
        }      
    }
        
    package { ['iceweasel', 'icedove']:
        ensure  => latest,
        require => Apt::Source['mozilla']
    } 
}
