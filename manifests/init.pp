class rabbitmq (
    $user,
    $password,
) {

    # TODO: Configure SSL for queue message transfer.

    require rabbitmq::requirements

    file {'/etc/rabbitmq/rabbitmq.config':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        content => template('queue/rabbitmq.config.erb'),
        notify  => Service['rabbitmq-server'],
    }

    file {'/etc/rabbitmq/enabled_plugins':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        content => template('queue/enabled_plugins.erb'),
        notify  => Service['rabbitmq-server'],
    }

    exec {'init-rabbitmq-user':
        command => "rabbitmqctl delete_user guest; rabbitmqctl add_user ${user} ${password} && rabbitmqctl set_user_tags ${user} administrator && rabbitmqctl set_permissions -p / ${user} '.*' '.*' '.*'",
        onlyif  => 'rabbitmqctl list_users | grep guest',
        path    => '/usr/bin:/usr/sbin:/bin',
    }

    service {'rabbitmq-server':
        ensure  => running,
        require => [File['/etc/rabbitmq/rabbitmq.config'], File['/etc/rabbitmq/enabled_plugins']],
    }

}
