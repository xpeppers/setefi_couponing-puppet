class couponing {
    file { '/etc/resolv.conf':
      ensure      => present,
      owner       => 'root',
      group       => 'root',
      mode        => 0644,
      content     => "nameserver 8.8.8.8\nnameserver 8.8.4.4\n",
      links       => follow,
      before      => Exec['apt-get update']
    }

    user { 'vagrant':
      groups => ['vagrant', 'admin', 'tomcat7']
    }

    exec { 'apt-get update':
      command => "/usr/bin/apt-get update -y",
    }

    package { 'python-software-properties':
      ensure => present,
      require => Exec['apt-get update']
    }

    exec { 'oracle-java6-installer-ppa':
      command => "/usr/bin/add-apt-repository -y ppa:webupd8team/java",
      require => Package['python-software-properties']
    }

    exec { 'apt-get update after ppa':
      command => "/usr/bin/apt-get update -y",
      require => [Exec['oracle-java6-installer-ppa'], Exec['nodejs-ppa']]
    }

    exec { 'nodejs-ppa':
      command => "/usr/bin/add-apt-repository -y ppa:chris-lea/node.js"
    }

    exec {
      'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';

      'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
    }

    package { ['oracle-java6-installer',
              'tomcat7',
              'tomcat7-admin',
              'git',
              'subversion',
              'nodejs']:
      ensure  => present,
      require => [Exec['apt-get update after ppa'],
                  Exec['set-licence-selected'],
                  Exec['set-licence-seen']]
    }

    file { '/etc/init.d/tomcat7':
      content => template('couponing/tomcat7.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => 755,
      require => Package['tomcat7']
    }

    file { '/etc/default/tomcat7':
      content => "TOMCAT7_USER=tomcat7\n
    TOMCAT7_GROUP=tomcat7\n
    JAVA_HOME=/usr/lib/jvm/java-6-oracle\n
    JAVA_OPTS=\"-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC\"\n",
      require => Package['tomcat7']
    }

    service { 'tomcat7':
      ensure => running,
      subscribe => [File['/etc/default/tomcat7'], File['/etc/init.d/tomcat7']]
    }
}
