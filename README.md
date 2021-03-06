Description
===========

Installs Apache hadoop and sets up a basic distributed cluster per the
quick start documentation.

Requirements
============

## Platform:

* Debian/Ubuntu

Tested on Ubuntu 10.4LTS, though should work on most Linux distributions,
see `hadoop[:java_home]`.

*IMPORTANT* REQUIRES a 64-bit box. CDH4 doesn't support i386 architecture. 

## Cookbooks:


Depends on
==========

* java

Recipes
=======

  * hadoop - Installs hadoop from Cloudera's repo
  * hadoop::conf_pseudo - Installs hadoop in pseudo-distributed mode and enables hadoop services
  * hadoop::doc  - Installs hadoop documentation
  * hadoop::hive - Installs hadoop's hive package
  * hadoop::pig  - Installs hadoop's pig package

Attributes
==========

* `hadoop[:mirror_url]` - Get a mirror from http://www.apache.org/dyn/closer.cgi/hadoop/core/.
* `hadoop[:version]` - Specify the version of hadoop to install.
* `hadoop[:uid]` - Default userid of the hadoop user.
* `hadoop[:gid]` - Default group for the hadoop user.
* `hadoop[:java_home]` - You will probably want to change this to match where Java is installed on your platform.


* `hadoop[:format_namenode]` - Set it to true if you want to format HDFS on the namenode (don't do it on a live fs unless you know what you're doing)



You may wish to add more attributes for tuning the configuration file templates.

If you're behind a proxy, you should define the attributes:
* node[:chef_client][:http_proxy]
* node[:chef_client][:http_proxy_user]
* node[:chef_client][:http_proxy_pass]

Usage
=====

This cookbook performs the tasks described in the Hadoop Quick
Start[1] to get the software installed. You should copy this to a
site-cookbook and modify the templates to meet your requirements.

Once the recipe is run, the distributed filesystem can be formated
using the script /usr/bin/hadoop.

    sudo -u hadoop /usr/bin/hadoop namenode -format
  
You may need to set up SSH keys for hadoop management commands. 

Note that this is not the 'default' config per se, so using the
start-all.sh script won't start the processes because the config files
live elsewhere. For running various hadoop processes as services, we
suggest runit. A sample 'run' script is provided. The HADOOP_LOG_DIR
in the run script must exist for each process. These could be wrapped
in a define.

* datanode
* jobtracker
* namenode
* tasktracker

[1] http://hadoop.apache.org/core/docs/current/quickstart.html


License and Author
==================

Author:: Joshua Timberman (<joshua@opscode.com>)
		 Modified by Inigo Gonzalez ( http://exocert.com )

Copyright:: 2009, Opscode, Inc
Portions Copyright:: 2013 Inigo Gonzalez

you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
