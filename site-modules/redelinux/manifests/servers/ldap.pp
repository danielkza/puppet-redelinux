class redelinux::servers::ldap
{
  File_util::Cfg {
    source_prefix => 'ldap'
  }

  package { 'slapd':
    ensure => installed
  }
}

