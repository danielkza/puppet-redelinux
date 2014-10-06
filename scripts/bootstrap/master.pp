class { 'puppet':
  server           => true,
  server_passenger => true,
  server_ca        => true,
  server_storeconfigs_backend => 'puppetdb',
  server_enc_api     => 'v2',
  server_report_api  => 'v2',
  server_foreman_url => 'https://foreman.linux.ime.usp.br'
}

class { 'puppetdb':
  require => Class['puppet']
}

class { 'puppetdb::master::config': 
  manage_storeconfigs     => false,
  manage_report_processor => false,
  require                 => Class['puppetdb']
}
