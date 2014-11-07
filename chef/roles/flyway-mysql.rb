name "flyway-mysql"
description "flyway mysql demo"
env_run_lists "_default" => %w[ apt openssl build-essential mysql::server java vagrant ]
override_attributes \
  :mysql => {
    :server_root_password => "password",
    :server_debian_password => "password",
    :server_repl_password => "password",
    :root_network_acl => ['0.0.0.0'],
    :allow_remote_root => true
  }
override_attributes \
  :java => {
    :install_flavor => "oracle",
    :jdk_version => "7",
    :oracle => { "accept_oracle_download_terms" => true }
  }
