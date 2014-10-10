class redelinux::servers::ldap
{
  Cfg_file {
    source_prefix => 'ldap'
  }

  package { 'slapd':
    ensure => installed
  }
}

