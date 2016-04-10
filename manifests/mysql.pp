# homer::mysql
class homer::mysql(
    $mysql_root_password
) {
    class { '::mysql::server':
        root_password           => $mysql_root_password,
        remove_default_accounts => true,
        override_options        => {
            mysqld => {
                bind-address => '0.0.0.0', # Allow remote connections
            }
        },
        restart                 => true,
    }
}
