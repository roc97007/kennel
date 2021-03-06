case $::operatingsystemrelease {

CentOS: {
	info "we have found CentOS"
}

LinuxMint: {
	info "we have found a mint!"
}

}

file { '/tmp/example-ip':
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
	class { 'ruby':
	gems_version  => 'latest'
	}
}

node 'peanut' {		#Settings for CentOS 7 server
	class {'apache': }
	apache::vhost {'iswizards.peanut.home':
	port => '8080',
	docroot => '/var/www/html'
	}
	class { 'ruby':
	gems_version  => 'latest'
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
	file { "/etc/cron.d/puppet":
		ensure => file,
		owner => root,
		group => root,
		mode => 0644,
		content => inline_template("<%= scope.function_fqdn_rand([60]) %> * * * * root /usr/bin/puppet agent --onetime --no-daemonize --no-splay\n"),
	}
}
