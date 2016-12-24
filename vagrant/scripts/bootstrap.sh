#!/bin/bash

application_name=$1
node_type=$2

header() {
  echo -ne "\x1B[92mBootstrap: \x1B[93m $1\x1B[0m\n"
}

if [[ -x /usr/bin/yum ]]; then
  PKG_MGR='/usr/bin/yum -d 0 -e 0 -y '
elif [[ -x /usr/bin/apt-get ]]; then
  PKG_MGR='/usr/bin/apt-get -q -y '
else
  echo "ERROR: No package manager identified"
  exit 1
fi

header "Updating packages"
sudo $PKG_MGR update
sudo $PKG_MGR install git

header "Installing r10k"
version=$(puppet --version)
if [[ ${version%%.*} -eq 4 ]]; then
  PUPPET_HOME=/opt/puppetlabs/puppet
  PUPPET_MODULES=${PUPPET_HOME}/modules
else
  PUPPET_HOME=/opt/puppet
  PUPPET_MODULES=${PUPPET_HOME}/share/puppet/modules
fi

${PUPPET_HOME}/bin/gem list | grep -q r10k || \
  sudo ${PUPPET_HOME}/bin/gem install r10k --no-ri --no-rdoc

PORT=
IP=
GIT_SERVER=
[[ -n $IP ]] && GIT_SERVER="${GIT_SERVER},${IP}"
[[ -n $PORT ]] && PORT="-p $PORT"
[[ -n $GIT_SERVER ]] && \
  header "Add local git server to known_hosts" && \
  ssh-keyscan $PORT $GIT_SERVER > ~/.ssh/known_hosts



header "Getting all the modules defined in Puppetfile with r10k"
VAGRANT_PUPPET_DIR=/vagrant/puppet
ENVIRONMENT=production
# Make sure vagrant user can write in the puppet/modules dir
sudo chmod 777 ${PUPPET_MODULES}

PUPPETFILE=${VAGRANT_PUPPET_DIR}/environments/${ENVIRONMENT}/modules/hieradata/Puppetfile \
PUPPETFILE_DIR=${PUPPET_MODULES} \
${PUPPET_HOME}/bin/r10k puppetfile install

header "Deleting the modules that are in this repository"
for m in ${VAGRANT_PUPPET_DIR}/environments/${ENVIRONMENT}/modules/*; do
  sudo rm -rf ${PUPPET_MODULES}/${m##*/}
done

header "Setting Custom Facts after provisioning"
EXTERNAL_FACTS_DIR=/etc/facter/facts.d
EXTERNAL_FACTS_FILE=${EXTERNAL_FACTS_DIR}/role.txt

sudo mkdir -p $EXTERNAL_FACTS_DIR
sudo rm -f $EXTERNAL_FACTS_FILE
echo "application_name=${application_name}" | sudo tee $EXTERNAL_FACTS_FILE
echo "node_type=${node_type}" | sudo tee --append $EXTERNAL_FACTS_FILE

header "Done"
