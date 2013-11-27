define nsswitch::nsswitch(
    $database   = $title,
    $services   = undef,
    $path       = '/etc/nsswitch.conf')
{
    if empty($database) {
        fatal("Invalid (empty) database")
    }

    if empty(services) {
        fatal("Invalid (empty) services")
    }

    if is_array($services) {
        $services_real = $services
    } else {
        $services_real = split($services, ' ')
    }
    
    Augeas {
        incl => $path,
        lens => 'nsswitch.lns',
        context => "/files/${path}"
    }

    $db_expr = "database[self::database = '${database}']"

    $additions = $services.each |$s| {
        "set $db_expr/service[last()+1] '${s}'"
    }

    augeas { "nsswitch_$title":
        changes => [
            "rm $db_expr/service"
        ] + $additions
    }
}