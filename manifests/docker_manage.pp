# homer::docker_manager.pp
class homer::docker_manager (
    $compose_dir,
    $mysql_host,
    $mysql_user,
    $mysql_password
) {
    # TODO: Include only optionally (e.g. add $manage_docker or similar)
    # sudo puppet module install garethr-docker
    class { 'docker':
    }

    file { $compose_dir:
        ensure  => directory,
    } ->
    file { "${compose_dir}/homer.env":
        ensure  => present,
        content => template('homer/docker-compose/homer.env.erb'),
    } ->
    file { "${compose_dir}/docker-compose.yml":
        ensure  => present,
        content => file('homer/docker-compose/docker-compose.yml'),
    } ->
    class { 'homer::docker_kamailio':
        compose_dir => $compose_dir,
    } ->
    class { 'homer::docker_web':
        compose_dir => $compose_dir,
    } ->
    docker_compose { "${compose_dir}/docker-compose.yml":
        ensure  => present,
    }
}
