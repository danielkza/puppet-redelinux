class redelinux::domain
{
  contain redelinux::domain::network
  contain redelinux::domain::ntp
  contain redelinux::domain::kerberos
  contain redelinux::domain::ldap
  contain redelinux::domain::nfs
}