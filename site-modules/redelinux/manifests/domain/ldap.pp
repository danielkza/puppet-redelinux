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

  util::cfg_file {
    '/etc/ldap/ldap.conf':
      ensure  => present;
    '/etc/nslcd.conf':
      ensure  => present,
      notify  => Service['nslcd']
      require => Package['libnss-ldapd'];
    '/etc/sysctl.d/90-max_keys.conf':
      ensure => present,
      before => Service['nslcd']
  }

  # Copy puppet certs somwhere else and ensure LDAP can read them properly
  # each({
  #   'certs/ca.pem'               => { name => 'ca.pem',         mode => '0644'},
  #   "certs/${::fqdn}.pem"        => { name => 'client.pem',     mode => '0644'},
  #   'crl.pem'                    => { name => 'crl.pem',        mode => '0644'},
  #   'private_keys/${::fqdn}.pem' => { name => 'client_key.pem', mode => '0600'}
  # }) |$path, $opts| {
  #   file { "/etc/ldap/${opts[name]}":
  #     ensure => present,
  #     source => "${ssldir}/${path}",
  #     mode   => $opts[mode],
  #     owner  => 'openldap',
  #     group  => 'openldap'
  #   }
  # }

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
tls_cacert /var/lib/puppet/ssl/certs/ca.pem
tls_cert /var/lib/puppet/ssl/certs/${::fqdn}.pem
tls_key /var/lib/puppet/ssl/private_keys/${::fqdn}.pem
tls_crlfile /var/lib/puppet/ssl/crl.pem
