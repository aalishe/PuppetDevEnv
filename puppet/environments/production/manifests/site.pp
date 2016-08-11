# Manifests: site.pp
#
# Defines Hiera as the External Node Classifier for all nodes
#
node default {
  hiera_include('classes')
}
