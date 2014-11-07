name "mysql"
description "MySql"
env_run_lists "_default" => %w[ apt openssl build-essential mysql::server vagrant ]
override_attributes \
	:mysql => {
		:server_root_password => "password",
		:server_debian_password => "password",
		:server_repl_password => "password",
		:root_network_acl => ['0.0.0.0']
	}
