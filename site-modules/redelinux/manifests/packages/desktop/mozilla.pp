class redelinux::packages::desktop::mozilla
{
  Package {
    ensure => installed
  }

  if $::operatingsystem == 'Debian' {
    if is_integer($::lsbmajdistrelease) && $::lsbmajdistrelease <= 7 { 
      apt::source { 'mozilla':
        location          => 'http://mozilla.debian.net',
        repos             => 'iceweasel-release',
        release           => '${::lsbdistcodename}-backports',
        required_packages => 'pkg-mozilla-archive-keyring',
        include_src       => true,
        before            => Package['iceweasel', 'icedove']
      }

      apt::pin { 'debian-mozilla':
        priority  => 501,
        release   => '${::lsbdistcodename}-backports',
        component => 'iceweasel-release',
        order     => 40,
        before    => Apt::Source['mozilla']
      }
    }
    
    package { ['iceweasel', 'icedove']: }
  } else {
    package { 'mozilla-firefox': }
  }
}
