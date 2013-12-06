class { '::puppet':
    server           => true,
    server_passenger => true,
    server_ca        => false,
    server_storeconfigs_backend => 'puppetdb',
    
    server_enc_api     => 'v2',
    server_report_api  => 'v2',
    server_foreman_url => 'https://elise.linux.ime.usp.br',
}

class { 'foreman::puppetmaster':
	foreman_url => "https://elise.linux.ime.usp.br",
	reports => true,
	enc     => true,
}