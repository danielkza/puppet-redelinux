class redelinux::repos(
  $use_backports   = undef,
  $use_foreman     = undef,
  $purge           = true
) {
  case $::operatingsystem {
    Debian: { 
      class { redelinux::repos::debian:
        use_backports => $use_backports
      }

      contain redelinux::repos::debian
    }
    Ubuntu: {
      class { redelinux::repos::ubuntu:
        use_backports => $use_backports
      }

      contain redelinux::repos::ubuntu
    }
    default: { fail("Unsupported operating system '${::operatingsystem}") }
  }

  if $purge {
    class { apt:
      purge_sources_list   => true,
      purge_sources_list_d => true,
      purge_preferences_d  => true,
    }
  } else {
    include apt
  }
  
  contain apt

  apt::source { 'redelinux':
    location   => 'http://apt.linux.ime.usp.br',
    release    => $::lsbdistcodename,
    repos      => 'main contrib non-free',
    key        => '1F48EB41',
    key_server => 'subkeys.pgp.net',
  }

  apt::pin { 'pin-redelinux':
    priority => 990,
    origin   => 'apt.linux.ime.usp.br',
    order    => 20,
  }

  if $use_foreman {
    apt::source { 'foreman':
      location    => 'http://deb.theforeman.org/',
      release     => $::lsbdistcodename,
      repos       => 'stable',
      include_src => false,
      key         => 'E775FF07',
      key_source  => 'http://deb.theforeman.org/foreman.asc',
    }
  }

  Class['Apt::Update'] -> Package<| |>
}
