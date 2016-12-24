# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

$puppetVersion = 4

# CentOS 7.2 64-bit (amd64/x86_64), no configuration management software
# config.vm.box = "puppetlabs/centos-7.2-64-nocm"

$box =  case $puppetVersion
          # CentOS 7.2 64-bit (amd64/x86_64), Puppet 4.3.2 / Puppet Enterprise 2015.3.2 (agent)
          when 4
            "puppetlabs/centos-7.2-64-puppet"
        end
$domain = "johandry.com"

infra = YAML.load_file('vagrant/config.yaml')

# Create the content of /etc/hosts to identify the servers.
$etc_hosts = ''
infra['servers'].each do |server|
  $etc_hosts += "#{server['ip']}\t#{server['name']}.#{$domain}\t#{server['name']}\n"
end

$common_host_setup = <<-COMMON_HOST_SHELL
  echo "*****************************"
  echo "*   Private network setup   *"
  echo "*****************************"
  tail -1 /etc/hosts | grep -q 'localhost' && echo "#{$etc_hosts}"      >> /etc/hosts
  grep -q '#{$domain}' /etc/resolv.conf    && echo "domain #{$domain}"  >> /etc/resolv.conf
COMMON_HOST_SHELL

Vagrant.configure(2) do |config|
  config.ssh.forward_agent = true

  # Issue on Vagrant 1.8.5: https://github.com/mitchellh/vagrant/issues/5186
  # config.ssh.insert_key = false

  infra['servers'].each do |server|
    config.vm.define server['name'] do |node|
      node.vm.box = $box
      node.vm.hostname = "#{server['name']}.#{$domain}"

      if server['ports'] != nil
        server['ports'].each do |p|
          ports = p.split(':')
          node.vm.network "forwarded_port", guest: ports[0], host: ports[1]
        end
      end

      node.vm.network "private_network", ip: server['ip']

      # node.vm.synced_folder "../data", "/vagrant_data"

      # node.vm.provider "virtualbox" do |vb|
      #   # Display the VirtualBox GUI when booting the machine
      #   vb.gui = true
      #
      #   # Customize the amount of memory on the VM:
      #   vb.memory = "1024"
      # end

      node.vm.provision "shell", inline: $common_host_setup

      # Required to load the hiera data file in roles/<app>/<type>.yaml
      # Example: roles/app/web.yaml
      $args = case server['name']
              when /001/
                ['myappname', 'web']
              when /002/
                ['myappname', 'app']
              else
                ['myappname', 'db']
              end

      node.vm.provision "shell",
        path: "vagrant/scripts/bootstrap.sh",
        args: $args,
        privileged: false

      node.vm.provision "puppet" do |puppet|
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
        # puppet.facter             = {
        #   fctr1: 'value1',
        #   fctr2: 'value2',
        # }

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
  end
end
