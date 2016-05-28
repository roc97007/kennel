file {'/tmp/example-ip':
	ensure => present,
	mode => 0644,
	content => "Here is my public IP address:  ${ipaddress_wlan0}.\n",
}

node 'bob' {		#Settings for CentOS 6 laptop
	class {'apache': }
	apache::vhost {'iswizards.peanut.home':
	port => '8080',
	docroot => '/var/www/html'
	}
}

node 'peanut' {		#Settings for CentOS 7 server
	class {'apache': }
	apache::vhost {'iswizards.peanut.home':
	port => '8080',
	docroot => '/var/www/html'
	}
}

node 'cody' {               #settings for node "cody"
        file {'/tmp/dns':
                ensure => present,
                mode => 0644, 
                content => "Test DNS servers only.\n",
        }
	file {'/opt/nwea/html/index.html':
		ensure => file,
		mode => 644,
		source => "puppet:///modules/nginx-content/index.html",
	}
	class {'nginx':
		manage_repo => true,
		package_source => 'nginx-mainline'
	}
	nginx::resource::vhost{'doggie.cody.home':
                listen_port => '8888',
                www_root => '/opt/nwea/html',
	}
}
