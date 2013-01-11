#
# Cookbook Name:: hadoop
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java"

execute "apt-get update" do
  action :nothing
end

# Nothing to do here. CDH4 installs this automatically
#template "/etc/apt/sources.list.d/cloudera.list" do
#  owner "root"
#  mode "0644"
#  source "cloudera.list.erb"
#  notifies :run, resources("execute[apt-get update]"), :immediately
#end

# Download and install the cd4h-repository package	
execute "curl -s http://archive.cloudera.com/cdh4/one-click-install/lucid/amd64/cdh4-repository_1.0_all.deb > cd4rep.deb ; dpkg -i cd4rep.deb" do
  not_if "apt-key export 'Cloudera Apt Repository'" 
end

package "hadoop"

