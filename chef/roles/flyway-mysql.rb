name "flyway-mysql"
description "flyway mysql demo"
override_attributes(
  :mysql => {
		:server_root_password => "password",
		:server_debian_password => "password",
		:server_repl_password => "password",
		:root_network_acl => ['0.0.0.0'],
		:allow_remote_root => true
	},
  :java => {
		:install_flavor => "oracle",
		:jdk_version => "7",
		:oracle => { "accept_oracle_download_terms" => true }
	}
)

# todo Need to look into why putting run list after attribute overrides successfully applies the overrides, but not vice versa, was recommended, I assume this role file is imperatively executed
env_run_lists "_default" => %w[ apt openssl build-essential mysql::server java vagrant ]
