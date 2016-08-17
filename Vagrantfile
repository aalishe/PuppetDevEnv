# -*- mode: ruby -*-
# vi: set ft=ruby :

$puppetVersion = 4

case $puppetVersion
when 4
  $box = "puppetlabs/centos-7.2-64-puppet"
end

Vagrant.configure(2) do |config|
  # CentOS 7.2 64-bit (amd64/x86_64), Puppet Enterprise 3.8.4 (agent)
  # config.vm.box = "puppetlabs/centos-7.2-64-puppet-enterprise"

  # CentOS 7.2 64-bit (amd64/x86_64), Puppet 4.3.2 / Puppet Enterprise 2015.3.2 (agent)
  config.vm.box = $box
  config.vm.hostname = "puppetlab"

  config.ssh.forward_agent = true

  # Issue on Vagrant 1.8.5: https://github.com/mitchellh/vagrant/issues/5186
  config.ssh.insert_key = false

  # CentOS 7.2 64-bit (amd64/x86_64), no configuration management software
  # config.vm.box = "puppetlabs/centos-7.2-64-nocm"

  # config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.network "forwarded_port", guest: 8080, host: 8080
  # config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "private_network", ip: "192.168.10.10"
  # config.vm.synced_folder "../data", "/vagrant_data"

  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end

  config.vm.provision "shell", path: "vagrant/scripts/bootstrap.sh", privileged: false

  config.vm.provision "puppet" do |puppet|
    if $puppetVersion == 3
      puppet.manifests_path     = "puppet/environments/production/manifests"
      puppet.manifest_file      = "site.pp"
      puppet.module_path        = "puppet/environments/production/modules"
    elsif $puppetVersion == 4
      puppet.environment        = "production"
      puppet.environment_path   = "puppet/environments"
    end

    # Hiera:
    puppet.hiera_config_path  = "puppet/hiera.yaml"
    # Facter:
    # Required to load the hiera data file in roles/<app>/<type>.yaml
    # Example: roles/app/web.yaml
    puppet.facter             = {
      'application_name'      => 'app',
      'node_type'             => 'web',
    }
    # Optional:
    # puppet.working_directory  = "/tmp/vagrant-puppet"
    puppet.options            = [
      '--verbose',
      '--debug',
      # '--evaltrace',
      # '--trace',
    ]
  end
end
