node base
{
	include redelinux
}

node /^puppet/ inherits base
{
}

node default inherits base
{
	include redelinux::puppet_client
}
