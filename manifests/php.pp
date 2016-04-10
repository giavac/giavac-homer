# homer::php.pp
class homer::php(
    $phpfpm_socket,
    $php_session_path,
    $web_user,
) {
    package { [
        'php5-common',
        'php5-mysql',
        'php5-fpm'
        ]:
        ensure => present,
    } ->
    # To store the "PHP sessions"
    # /var/lib/php is installed by 'php-common'
    file { $php_session_path:
        ensure => directory,
        owner  => 'root',
        group  => 'root',
        mode   => '0777',
    } ->
    file { '/etc/php5/fpm/pool.d/www.conf':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('homer/php/php-fpm-www.conf.erb'),
        notify  => Service['php5-fpm'],
    }

    service { 'php5-fpm':
        ensure => running,
        enable => true,
    } ->
    file { $phpfpm_socket:
        ensure => present,
        owner  => $web_user,
        group  => $web_user,
    }
}
