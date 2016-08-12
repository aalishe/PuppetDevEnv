# PuppetDevEnv
Development Environment for Puppet

## TODO
- [ ] Complete the README
- [ ] Create a Dockerfile to have both options. Get ideas from: https://blogs.cornell.edu/cloudification/2016/07/26/docker-puppet-win/
- [ ] Create Packer files to build the image. Get ideas from:  https://github.com/puppetlabs/puppetlabs-packer
- [X] Hiera integration
- [X] Use r10k to get modules
- [ ] Delete modules downloaded with r10k that are in this repository, including the submodules.
- [ ] Configure in the Vagrantfile to select the OS (Centos, Ubuntu) and Puppet (3, 4). Boxes here: https://atlas.hashicorp.com/puppetlabs
- [ ] Vagrantfile refactoring. Move stuffs to /vagrant
- [ ] Add the modules to test in a file, to be added as submodules. Get ideas from: http://www.erikaheidi.com/blog/a-beginners-guide-to-vagrant-and-puppet-part-3-facts-conditional and https://github.com/vagrantee/vagrantee
- [ ] Create scripts to run puppet and r10k from vagrant box. Get ideas from: https://github.com/pall-valmundsson/vagrant-puppet-r10k-bootstrap and https://github.com/puppetlabs/r10k
- [ ] Include Vagrantservers to create multi-hosts
- [ ] Create a Makefile for all
- [ ] Add hostnames/ips from Vagrantservers to /etc/hosts, ?using Puppet?
- [ ] Make sure SELinux is disabled, ?using puppet-selinux?
