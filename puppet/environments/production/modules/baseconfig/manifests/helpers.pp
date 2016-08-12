# Class: baseconfig::helpers
# ===========================
#
# Full description of class baseconfig::helpers here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'baseconfig::helpers':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class baseconfig::helpers (
){
  $puppet_dir         = '/opt/puppetlabs/puppet'
  $vagrant_puppet_dir = '/vagrant/puppet'

  file { '/usr/local/bin/run-puppet':
    content     => "sudo ${puppet_dir}/bin/puppet apply -vt --modulepath=${puppet_dir}/modules:${vagrant_puppet_dir}/environments/production/modules ${vagrant_puppet_dir}/environments/production/manifests/site.pp\n",
    mode        => '0755',
  }

  file { '/usr/local/bin/run-r10k':
    content     => "PUPPETFILE=${vagrant_puppet_dir}/environments/production/modules/hieradata/Puppetfile PUPPETFILE_DIR=${puppet_dir}/modules  sudo ${puppet_dir}/bin/r10k puppetfile install",
    mode        => '0755',
  }
}
