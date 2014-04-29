class rabbitmq::requirements {

    apt::source {'rabbitmq':
        location   => 'http://www.rabbitmq.com/debian/',
        repos      => 'main',
        release    => 'testing',
        key        => '056E8E56',
        key_source => 'http://www.rabbitmq.com/rabbitmq-signing-key-public.asc',
    }

    package {'rabbitmq-server':
        ensure => '3.3.0-1',
        require => Apt::Source['rabbitmq'],
    }


}
