include_recipe 'apt'
apt_package "ruby1.9.1-dev" do
  action :install
end

include_recipe 'mysql::server'
include_recipe 'database::mysql'

mysql_connection_info = {:host => "localhost",
                         :username => 'root',
                         :password => node['mysql']['server_root_password']}
						 
mysql_database_user 'vagrant' do
  connection mysql_connection_info
  action :grant
end
