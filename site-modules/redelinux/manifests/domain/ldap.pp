class redelinux::ldap
{
  Redelinux::Util::Cfg_file {
    source_prefix => "ldap"
  }
  # We only want LDAP authentication, authorization is Kerberos' job
  package {
    ['libnss-ldapd', 'kstart']:
      ensure => installed,
      tag    => 'ldap-pkg';
    'libpam-ldapd':
      ensure => absent,
      tag    => 'ldap-pkg';
  }

  service { 'nslcd':
    ensure  => running,
    enable  => true
  }

  file { '/etc/ldap/ldap.conf':
    ensure  => absent,
    tag     => 'ldap-cfg'
  }

  util::cfg_file { '/etc/nslcd.conf':
    tag => 'ldap-cfg'
  }

  nsswitch::database { ['passwd', 'group', 'shadow']:
    services => 'files ldap',
    tag      => 'ldap-cfg'
  }

  Package <| tag == 'redelinux::ldap' |> ->
    Service <| tag == 'redelinux::ldap' |>
}
