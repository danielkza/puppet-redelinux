class { '::puppet':
    server           => true,
    server_passenger => true,
    
    server_ca        => false,
    ca_server        => 'foreman.linux.ime.usp.br',
    server_storeconfigs_backend => 'puppetdb',
    
    server_enc_api     => 'v2',
    server_report_api  => 'v2',
    server_foreman_url => 'https://foreman.linux.ime.usp.br',
}