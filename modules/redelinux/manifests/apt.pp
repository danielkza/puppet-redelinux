class redelinux::apt(
    $mirror = undef
) {
    include redelinux::params

    $mirror_real = $mirror ? {
        undef   => $params::debian_mirror,
        default => $mirror
    }

    class { '::apt': 
        purge_sources_list   => true,
        purge_sources_list_d => true
    }

    if $params::debian_pre_wheezy
    {
        # Add backports repo
        class { '::apt::backports': }

        # Add testing repo. Very low priority, so by default nothing will
        # ever be installed from it
        ::apt::source { 'debian_wheezy': 
            location          => $mirror_real,
            release           => 'wheezy',
            repos             => 'main contrib non-free',
            include_src       => true,
            required_packages => 'debian-keyring debian-archive-keyring',
            pin               => '-10',
        }
    }

    ::apt::source { "debian_${::lsbdistcodename}":
        location          => $mirror_real,
        repos             => 'main contrib non-free',
        include_src       => true,
        required_packages => 'debian-keyring debian-archive-keyring',
    }

    ::apt::source { "debian_${::lsbdistcodename}_security":
        location          => 'http://security.debian.org',
        repos             => 'main contrib non-free',
        release           => "${::lsbdistcodename}/updates",
        include_src       => true,
    }

    ::apt::source { 'puppetlabs':
        location          => 'http://apt.puppetlabs.com',
        repos             => 'main',
        include_src       => true,
        key               => '4BD6EC30',
        key_server        => 'subkeys.pgp.net'
    }

    ::apt::source { 'sublime-text':
        location    => 'http://ppa.launchpad.net/webupd8team/sublime-text-2/ubuntu',
        repos       => 'main',
        release     => 'precise',
        include_src => true,
        key         => 'EEA14886',
        key_server  => 'keyserver.ubuntu.com',
    }
}
