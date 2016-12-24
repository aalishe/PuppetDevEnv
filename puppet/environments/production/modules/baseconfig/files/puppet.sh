
run-puppet() {
  if [ "$(id -u)" != "0" ]; then
     echo "This script must be run as root" 1>&2
     exit 1
  fi

  testopt=
  [[ "$1" == "-d" ]] && testopt='--test --debug' # --verbose'

  version=$(puppet --version)
  if [[ ${version%%.*} -eq 4 ]]; then
    puppet_dir="/opt/puppetlabs/puppet"
    modules_dir="${puppet_dir}/modules"
  else
    puppet_dir="/opt/puppet"
    modules_dir="${puppet_dir}/share/puppet/modules"
  fi

  vagrant_puppet_dir='/vagrant/puppet'
  environment='production'

  ${puppet_dir}/bin/puppet apply $testopt \
    --modulepath=${modules_dir}:${vagrant_puppet_dir}/environments/${environment}/modules \
    --environment=${environment} \
    --hiera_config=${vagrant_puppet_dir}/hiera.yaml \
    ${vagrant_puppet_dir}/environments/${environment}/manifests/site.pp
}

run-r10k() {
  if [ "$(id -u)" == "0" ]; then
     echo "This script cannot be run as root" 1>&2
     exit 1
  fi

  version=$(puppet --version)
  if [[ ${version%%.*} -eq 4 ]]; then
    puppet_dir="/opt/puppetlabs/puppet"
    modules_dir="${puppet_dir}/modules"
  else
    puppet_dir="/opt/puppet"
    modules_dir="${puppet_dir}/share/puppet/modules"
  fi

  vagrant_puppet_dir='/vagrant/puppet'
  environment='production'

  PUPPETFILE=${vagrant_puppet_dir}/environments/${environment}/modules/hieradata/Puppetfile \
  PUPPETFILE_DIR=${modules_dir} \
  ${puppet_dir}/bin/r10k puppetfile install

  # Delete the modules that are in this repository
  for m in ${vagrant_puppet_dir}/environments/${environment}/modules/*; do
    sudo rm -rf ${modules_dir}/${m##*/}
  done
}
