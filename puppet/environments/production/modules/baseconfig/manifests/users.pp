# Class: baseconfig::users
# ===========================
#
# Full description of class baseconfig::users here.
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
#    class { 'baseconfig::users':
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
class baseconfig::users (
    $username,
    $password,
    $sshPublicKey,
){
  file { '/home/vagrant/.bashrc':
    ensure      => file,
    owner       => 'vagrant',
    group       => 'vagrant',
    mode        => '0644',
    source      => 'puppet:///modules/baseconfig/bashrc',
  } ->
  group { $username:
    ensure      => present,
  } ->
  user { $username:
    ensure      => present,
    home        => "/home/${username}",
    managehome  => true,
    gid         => $username,
    groups      => [ "${username}", 'wheel' ]
    comment     => 'Application Admin user',
    shell       => '/bin/bash',
    password    => inline_template('<%=
      # $6$: SHA-512
      # rounds=5120$: 5120 times the hashing loop should be executed
      # Salt: #{@fqdn} = hostname + domainname
      @password.crypt("$6$rounds=5120$#{@fqdn}")
    %>'),
  } ->
  file { "/home/${username}":
    ensure      => directory,
    mode        => '0750',
    owner       => $username,
    group       => $username,
  } ->
  file { "/home/${username}"/.bashrc":
    ensure      => file,
    owner       => $username,
    group       => $username,
    mode        => '0644',
    source      => 'puppet:///modules/baseconfig/bashrc',
  } ->
  file { "/home/${username}/.ssh":
    ensure      => directory,
    mode        => '0600',
    owner       => $username,
    group       => $username,
  }

  if $sshPublicKey == '' {
    ssh_authorized_key { "${username}_key":
      ensure    => absent,
      user      => $username,
      require   => File["/home/${username}/.ssh"],
    }
  } else {
    ssh_authorized_key { "${username}_key":
      ensure    => present,
      user      => $username,
      key       => $sshPublicKey,
      type      => 'ssh-rsa',
      require   => File["/home/${username}/.ssh"],
    }
  }
}
