# homer::kamailio
class homer::kamailio(
    $listen_proto,
    $listen_if,
    $listen_port,
    $kamailio_etc_dir,
    $kamailio_mpath,
    $mysql_user,
    $mysql_password,
) {
    include 'homer::kamailio::apt'

    # TODO: refine this conditional
    case $::operatingsystem {
        'Ubuntu': { $manage_systemd = false }
        'Debian': { $manage_systemd = false }
        default : { $manage_systemd = true }
    }

    package { ['kamailio',
               'kamailio-geoip-modules',
               'kamailio-utils-modules',
               'kamailio-mysql-modules']:
        ensure => present,
    } ->
    file { $kamailio_etc_dir:
        ensure => directory,
    } ->
    file { "${kamailio_etc_dir}/kamailio.cfg":
        ensure  => present,
        owner   => 'kamailio',
        group   => 'kamailio',
        content => file('homer/kamailio/kamailio.cfg'),
        notify  => Service['kamailio'],
    } ->
    file { "${kamailio_etc_dir}/kamailio-local.cfg":
        ensure  => present,
        owner   => 'kamailio',
        group   => 'kamailio',
        content => template('homer/kamailio/kamailio-local.cfg.erb'),
        notify  => Service['kamailio'],
    } ->
    file { "${kamailio_etc_dir}/kamctlrc":
        ensure  => present,
        owner   => 'kamailio',
        group   => 'kamailio',
        content => file('homer/kamailio/kamctlrc'),
        notify  => Service['kamailio'],
    } ->
    file { '/etc/default/kamailio':
        ensure  => present,
        content => file('homer/kamailio/default')
    }

    if ($manage_systemd) {
        file { '/etc/sysconfig':
            ensure  => directory,
        } ->
        file { '/etc/sysconfig/kamailio':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            content => template('homer/kamailio/etc_sysconfig_kamailio.erb'),
            notify  => Service['kamailio'],
        }
    
        file { '/usr/lib/systemd/system/kamailio.service':
            ensure  => present,
            owner   => 'root',
            group   => 'root',
            content => template('homer/kamailio/systemd_kamailio.erb'),
            notify  => [Exec['kamailio-systemd-reload'], Service['kamailio']],
        }
    
        exec { 'kamailio-systemd-reload':
            command     => 'systemctl daemon-reload',
            path        => '/bin',
            refreshonly => true,
        }
    }

    service { 'kamailio':
        ensure => running,
        enable => true,
    }
}
