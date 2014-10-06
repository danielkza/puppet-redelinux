class redelinux::packages::desktop::mozilla
{
  Package {
    ensure => installed
  }

  if $::operatingsystem == 'Debian' && $::lsbmajdistrelease <= 7 { 
    apt::source { 'mozilla':
      location          => 'http://mozilla.debian.net',
      repos             => 'iceweasel-release',
      release           => '${::lsbdistcodename}-backports',
      required_packages => 'pkg-mozilla-archive-keyring',
      include_src       => true
    }

    apt::pin { 'debian-mozilla':
      priority  => 501,
      release   => '${::lsbdistcodename}-backports',
      component => 'iceweasel-release',
      order     => 40,
      before    => Apt::Source['mozilla']
    }

    Apt::Source['mozilla'] -> Package['iceweasel', 'icedove']
  }
  
  package { ['iceweasel', 'icedove']: }
}
