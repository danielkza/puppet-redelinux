class redelinux::repos(
  $use_backports   = undef,
  $purge           = true
) {
  class { 'apt':
    apt_update_frequency => 'daily',
    fancy_progress       => true
  }

  if $purge {
    Class['apt'] {
      purge_sources_list   => true,
      purge_sources_list_d => false,
      purge_preferences_d  => false
    }
  }
  
  contain apt

  case $::operatingsystem {
    Debian: { 
      class { 'redelinux::repos::debian':
        use_backports => $use_backports
      }

      contain redelinux::repos::debian
    }
    Ubuntu: {
      class { 'redelinux::repos::ubuntu':
        use_backports => $use_backports
      }

      contain redelinux::repos::ubuntu
    }
    default: { 
      fail("Unsupported operating system '${::operatingsystem}")
    }
  }

  apt::source { 'redelinux':
    location   => 'http://apt.linux.ime.usp.br',
    release    => $::lsbdistcodename,
    repos      => 'main contrib non-free',
    key        => '1F48EB41',
    key_server => 'subkeys.pgp.net',
  }

  apt_key { 'puppetlabs':
    source => 'https://apt.puppetlabs.com/keyring.gpg',
  }
  
  apt::source { 'puppetlabs':
    location => 'http://apt.puppetlabs.com',
    release  => $::lsbdistcodename,
    repos    => 'main',
    require  => Apt_key['puppetlabs'],
  }

  apt::pin { 'redelinux':
    priority => 520,
    origin   => 'apt.linux.ime.usp.br',
    order    => 20,
  }

  # if $use_foreman {
  #   apt::source { 'foreman':
  #     location    => 'http://deb.theforeman.org/',
  #     release     => $::lsbdistcodename,
  #     repos       => 'stable',
  #     include_src => false,
  #     key         => 'E775FF07',
  #     key_source  => 'http://deb.theforeman.org/foreman.asc',
  #   }
  # }
}
