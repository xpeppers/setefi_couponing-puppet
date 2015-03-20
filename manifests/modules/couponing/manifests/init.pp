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
      require => Exec['oracle-java6-installer-ppa']
    }

    exec {
      'set-licence-selected':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections';

      'set-licence-seen':
      command => '/bin/echo debconf shared/accepted-oracle-license-v1-1 seen true | /usr/bin/debconf-set-selections';
    }

    exec { 'buildr installing':
      command => "/home/vagrant gem install buildr",
      require => Package['ruby-full']
    }

    package { ['oracle-java6-installer',
              'tomcat7',
              'git',
              'subversion',
              'apache2',
              'ant',
              'ruby-full',
              'ccze',
              'rubygems',
              'libsvn-java',
              'sqsh',
              'colordiff',
              'curl',
              'openssh-server',
              'ack-grep',
              'apache2-utils',
              'httperf',
              'libapache2-mod-perl2',
              'apache2-threaded-dev',
              'libaprutil1-dev',
              'libipc-sharelite-perl',
              'libapache2-request-perl',
              'ntp',
              'ag']:
      ensure  => present,
      require => [Exec['apt-get update after ppa'],
                  Exec['set-licence-selected'],
                  Exec['set-licence-seen']]
    }

}
