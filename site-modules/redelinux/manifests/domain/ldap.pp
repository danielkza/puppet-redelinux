class redelinux::domain::ldap
{
  Util::Cfg_file {
    source_prefix => 'ldap'
  }

  # We only want LDAP authentication, authorization is Kerberos' job
  package {
    ['libnss-ldapd', 'libsasl2-modules-gssapi-mit', 'kstart']:
      ensure => installed,
      before => Service['nslcd'];
    'libpam-ldapd':
      ensure => absent,
      after  => Package['libnss-ldapd']
  }

  file { 'ldap.conf':
    path    => '/etc/ldap/ldap.conf'
    ensure  => absent,
    notify  => Service['nslcd'],
    require => Package['libnss-ldapd']
  }

  util::cfg_file { ['/etc/nslcd.conf', '/etc/ldap/ca.crt']:
    notify        => Service['nslcd']
    require       => Package['libnss-ldapd']
  }

  nsswitch::database { ['passwd', 'group', 'shadow']:
    services => 'compat ldap',
    notify   => Service['nslcd'],
    require  => Package['libnss-ldapd']
  }

  service { 'nslcd':
    ensure => running,
    enable => true
  }
}
