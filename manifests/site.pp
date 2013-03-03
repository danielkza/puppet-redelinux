node base
{
    include redelinux
    include redelinux::network
    include redelinux::apt
    include redelinux::ntp
    include redelinux::kerberos
    include redelinux::ldap
    include redelinux::nfs
    include redelinux::nsswitch
    #include redelinux::ssh

    include redelinux::programming

}

node /^puppet/ inherits base
{
}

node default inherits base
{
	include redelinux::puppet_client
}
