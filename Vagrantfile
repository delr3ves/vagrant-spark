# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "spark-single-node"
  config.vm.hostname = "spark-master"

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.vm.box = "puppetlabs/ubuntu-14.04-64-puppet"
  config.vm.box_version = "1.0.0"

  config.vm.network :forwarded_port, guest: 7077, host: 17077
  config.vm.network :forwarded_port, guest: 8080, host: 18080
  config.vm.network :forwarded_port, guest: 8081, host: 18081
  config.vm.network :forwarded_port, guest: 8082, host: 18082

  config.vm.network :private_network, ip: "192.168.7.10"

  config.vm.synced_folder "../", "/opt/theevnt-spark", type: "nfs"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider :virtualbox do |vb|
     vb.customize ["modifyvm", :id, "--cpus", "2", "--memory", "2048"]
  end

  config.vm.provision :puppet do |puppet|
    puppet.manifest_file = "default.pp"
    puppet.module_path = "modules"
    puppet.manifests_path = "manifests"
  end

end

