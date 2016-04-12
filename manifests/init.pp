# == Class: homer
#
# Install and configure Homer sipcapture (https://github.com/sipcapture/homer).
#
# === Parameters
#
# Document parameters here.
#
# [*base_dir*]
#   Path to install Homer mysql scripts
#   Defaults to '/opt/homer'
#
# [*listen_if*]
#   Interface for kamailio to listen to
#   Defaults to '0.0.0.0'

# [*listen_port*]
#   Port for kamailio to listen to
#   Defaults to '9060'
#
# [*listen_proto*]
#   Proto for kamailio to listen to
#   Defaults to 'udp'
#
# [*kamailio_etc_dir*]
#   Path to install all the etc/ files for kamailio
#   Defaults to '/etc/kamailio'
#
# [*kamailio_mpath*]
#   Path where to find the kamailio modules
#   Defaults to '/usr/lib/x86_64-linux-gnu/kamailio/modules'
#
# [*manage_mysql*]
#   Whether it should install and run mysql
#   Defaults to false
#
# [*mysql_host*]
#   mysql host
#   Defaults to '127.0.0.1'
#
# [*mysql_user*]
#   mysql user
#   Defaults to 'sipcapture'
#
# [*mysql_password*]
#   mysql password for mysql_user
#
# [*mysql_root_password*]
#   mysql password for root
#
# [*phpfpm_socket*]
#   Full path for php-fpm socket
#   Defaults to '/var/run/php5-fpm.sock'
#
# [*php_session_path*]
#   Full path of dir to store session details
#   Defaults to '/var/lib/php5/session'
#
# [*source_dir*]
#   Full path of dir where homer-ui and homer-api source code is located
#   Defaults to 'root'
#
# [*web_dir*]
#   Full installation path for web files (UI and API)
#   Defaults to '/var/www/sipcapture'
#
# [*web_user*]
#   User for web server and php-fpm
#   Defaults to 'www-data'
#
# [*ui_admin_password*]
#   Password for UI admin user
#
# [*use_docker*]
#   Whether to install Docker containers or directly on host
#   Defaults to false
#
# === Examples
#
#  class { homer:
#        manage_mysql        => true,
#        mysql_password      => 'astrongone',
#        mysql_root_password => 'averystrongone',
#        ui_admin_password   => 'theadmin123',
#  }
#
# === Authors
#
# Giacomo Vacca <giacomo.vacca@gmail.com>
#
class homer(
    $base_dir            = $homer::params::base_dir,
    $listen_if           = $homer::params::listen_if,
    $listen_port         = $homer::params::listen_port,
    $listen_proto        = $homer::params::listen_proto,
    $kamailio_etc_dir    = $homer::params::kamailio_etc_dir,
    $kamailio_mpath      = $homer::params::kamailio_mpath,
    $manage_mysql        = $homer::params::manage_mysql,
    $mysql_host          = $homer::params::mysql_host,
    $mysql_user          = $homer::params::mysql_user,
    $mysql_password      = $homer::params::mysql_password,
    $mysql_root_password = $homer::params::mysql_root_password,
    $phpfpm_socket       = $homer::params::phpfpm_socket,
    $php_session_path    = $homer::params::php_session_path,
    $source_dir          = $homer::params::source_dir,
    $web_dir             = $homer::params::web_dir,
    $web_user            = $homer::params::web_user,
    $ui_admin_password   = $homer::params::ui_admin_password,
    $use_docker          = $homer::params::use_docker,
) inherits homer::params {
    validate_bool($manage_mysql)
    validate_bool($use_docker)

    if $ui_admin_password == undef {
        fail('You must define ui_admin_password')
    }

    if ($manage_mysql) {
        if $mysql_password == undef {
            fail('You must define mysql_password')
        }

        if $mysql_root_password == undef {
            fail('You must define mysql_root_password')
        }

        class { 'homer::mysql':
            mysql_root_password => $mysql_root_password,
        }
    }

    if ($use_docker) {
        class { 'homer::docker_manager':
            compose_dir    => $compose_dir,
            mysql_host     => $mysql_host,
            mysql_user     => $mysql_user,
            mysql_password => $mysql_password
        }
    }
    else {
        class { 'homer::mysql::scripts':
            base_dir            => $base_dir,
            mysql_host          => $mysql_host,
            mysql_user          => $mysql_user,
            mysql_password      => $mysql_password,
            mysql_root_password => $mysql_root_password,
            ui_admin_password   => $ui_admin_password,
        } ->
        class { 'homer::web':
            base_dir       => $base_dir,
            mysql_user     => $mysql_user,
            mysql_password => $mysql_password,
            phpfpm_socket  => $phpfpm_socket,
            source_dir     => $source_dir,
            web_dir        => $web_dir,
            web_user       => $web_user,
        } ->
        class { 'homer::php':
            php_session_path => $php_session_path,
            phpfpm_socket    => $phpfpm_socket,
            web_user         => $web_user,
        } ->
        class { 'homer::kamailio':
            listen_proto     => $listen_proto,
            listen_if        => $listen_if,
            listen_port      => $listen_port,
            kamailio_etc_dir => $kamailio_etc_dir,
            kamailio_mpath   => $kamailio_mpath,
            mysql_password   => $mysql_password,
            mysql_user       => $mysql_user,
        }
    }
}
