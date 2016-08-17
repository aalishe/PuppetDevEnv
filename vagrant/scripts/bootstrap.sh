#!/bin/bash

if [[ -x /usr/bin/yum ]]; then
  PKG_MGR=/usr/bin/yum
elif [[ -x /usr/bin/apt-get ]]; then
  PKG_MGR=/usr/bin/apt-get
else
  echo "ERROR: No package manager identified"
  exit 1
fi

# Update and install dependencies
sudo $PKG_MGR -q -y update
sudo $PKG_MGR -q -y install git

# Install r10k using the gem from puppet
version=$(puppet --version)
if [[ ${version%%.*} -eq 4 ]]; then
  PUPPET_HOME=/opt/puppetlabs/puppet
  PUPPET_MODULES=${PUPPET_HOME}/modules
else
  PUPPET_HOME=/opt/puppet
  PUPPET_MODULES=${PUPPET_HOME}/share/puppet/modules
fi

sudo ${PUPPET_HOME}/bin/gem install r10k --no-ri --no-rdoc

# Get all the modules defined in Puppetfile with r10k
VAGRANT_PUPPET_DIR=/vagrant/puppet
ENVIRONMENT=production

sudo chmod 777 ${PUPPET_MODULES}

# Add git server to known_hosts (if required)
PORT=
IP=
GIT_SERVER=
[[ -n $IP ]] && GIT_SERVER="${GIT_SERVER},${IP}"
[[ -n $PORT ]] && PORT="-p $PORT"
[[ -n $GIT_SERVER ]] && ssh-keyscan $PORT $GIT_SERVER > ~/.ssh/known_hosts

PUPPETFILE=${VAGRANT_PUPPET_DIR}/environments/${ENVIRONMENT}/modules/hieradata/Puppetfile \
PUPPETFILE_DIR=${PUPPET_MODULES} \
${PUPPET_HOME}/bin/r10k puppetfile install

# Delete the modules that are in this repository
for m in ${VAGRANT_PUPPET_DIR}/environments/${ENVIRONMENT}/modules/*; do
  sudo rm -rf ${PUPPET_MODULES}/${m##*/}
done
