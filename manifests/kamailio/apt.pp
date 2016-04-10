# homer::kamailio::apt
class homer::kamailio::apt(
) {
    include '::apt'

    package { ['debian-keyring', 'debian-archive-keyring']:
        ensure => present,
    }

    apt::source { "kamailio_${::lsbdistcodename}":
        location          => 'http://deb.kamailio.org/kamailio43',
        release           => $::lsbdistcodename,
        repos             => 'main',
        key               => {
            id     => 'E79ACECB87D8DCD23A20AD2FFB40D3E6508EA4C8',
            source => 'http://deb.kamailio.org/kamailiodebkey.gpg',
        },
        include           => {
            src => true,
        },
    }

    Apt::Source["kamailio_${::lsbdistcodename}"] -> Package<|tag == 'kamailio'|>
}
