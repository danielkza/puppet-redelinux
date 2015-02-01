define redelinux::keytab(
  $path = $title,
  $principals,
  $create_principals = true,
  $owner = 'root',
  $group = 'root',
  $mode  = '0600'
) {
  if validate_array($principals) {
    each($principals) |$princ| {
      if empty($princ) or ! validate_string($princ) {
        fail("Invalid principal $princ")
      }
    }
  } else {
    fail("Invalid principals, not an array")
  }

  each($principals) |$princ| {
    if($create_principals) {
      krb5_ensure_principal($princ)   
    } else if empty(krb5_list_principals($princ)) {
      fail("Principal $princ does not exist")
    }
  }

  file { "redelinux_keytab_$title":
    ensure  => file,
    path    => $path,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => krb5_generate_keytab($principals)
  }
}
