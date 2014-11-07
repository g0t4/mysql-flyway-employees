# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3306, host: 33306, id: "mysql"

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ["chef/cookbooks","chef/mybooks"]
    chef.roles_path = "chef/roles"
    chef.add_role "mysql"
  end

end
