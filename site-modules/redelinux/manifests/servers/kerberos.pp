class redelinux::servers::kerberos
{
  Cfg_file {
    source_prefix => 'kerberos'
  }

  package { ['krb5-admin-server', 'krb5-kdc']:
    ensure => installed
  }

  cfg_file { ['/etc/krb5.conf', '/etc/krb5kdc/kdc.conf']:
    ensure  => present,
    require => Package['krb5-kdc'],
    before  => Exec['krb5-kdc-create-db'],
    notify  => Service['krb5-kdc']
  }

  cfg_file { '/etc/krb5kdc/kadm5.acl':
    ensure  => present,
    require => Package['krb5-admin-server'],
    notify  => Service['krb5-admin-server']
  }

  $kdc_pw = hiera('redelinux::secrets::kerberos-kdc')
  exec { 'krb5-kdc-create-db':
    command  => ["kdb5_util -P '${kdc_pw}' create -s"],
    creates  => '/var/lib/krb5kdc/principal',
    path     => ['/usr/bin', '/usr/sbin', '/bin', '/sbin'],
    provider => 'shell',
    require  => Package['krb5-kdc'],
    notify   => Service['krb5-kdc']
  }

  service {
    'krb5-kdc':
      ensure  => running,
      enabled => true;
    'krb5-admin-server':
      ensure  => running,
      enabled => true,
      require => Service['krb5-kdc']
  }
}
