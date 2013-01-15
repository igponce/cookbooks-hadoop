name              "hadoop"
maintainer        "Opscode, Inc."
maintainer_email  "cookbooks@opscode.com"
license           "Apache 2.0"
description       "Installs hadoop and sets up basic cluster per Cloudera's quick start docs"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.8.1"
depends           "java"

recipe "hadoop", "Installs hadoop from Cloudera's repo"
recipe "hadoop::conf_pseudo", "Installs hadoop in pseudo-distributed mode and enables hadoop services"
recipe "hadoop::doc", "Installs hadoop documentation"
recipe "hadoop::hive", "Installs hadoop's hive package"
recipe "hadoop::pig", "Installs hadoop's pig package"

%w{ debian ubuntu }.each do |os|
  
  # I think this is the beginning of a beautiful bug report:

   # http://wiki.opscode.com/display/chef/Metadata
  # Currently, the platform matching and version checking logic is not implemented - Chef will happily run any cookbook on any platform, regardless of the data provided here.

  ml = Mixlib::ShellOut.new("dpkg --print-architecture")
  ml.run_command
  debian_arch = ml.stdout unless ml.error!
  supports os unless debian_arch != 'amd64'

end
