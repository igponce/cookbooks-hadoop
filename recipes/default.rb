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

# Download and install the cd4h-repository package from cloudera quickstart instructions

if node[:platform_family] == 'debian'

    # Detect debian architecture inside a CHEF recice
	ml = Mixlib::ShellOut.new("dpkg --print-architecture")
	ml.run_command
	debian_arch = ml.stdout unless ml.error!
	puts debian_arch

    # Proxy setup for apt-get and curl
    newenv_http_proxy = node["chef_client"]["http_proxy"] unless node["chef_client"]["http_proxy"].nil?
    newenv_http_proxy.insert( newenv_http_proxy.index('http://') + 7, node["chef_client"]["http_proxy_user"] + '@' ) unless node["chef_client"]["http_proxy_user"].nil?
    newenv_http_proxy.insert( newenv_http_proxy.index('@'), ':' + node["chef_client"]["http_proxy_pass"] ) unless node["chef_client"]["http_proxy_pass"].nil?

	ENV["HTTP_PROXY"] = newenv_http_proxy unless node["chef_client"]["http_proxy"].nil?
	ENV["http_proxy"] = newenv_http_proxy unless node["chef_client"]["http_proxy"].nil?

	execute "apt-get update" do
	  action :nothing
	end

	# pkgarch = execute "get debian pkg architecture" do
 #       result = command "dpkg --print-architecture"
 #       puts "************"
 #       puts result.inspect
 #       puts result
	#    puts "************"
	#    action :run
	# end


	dpkgurl = "http://archive.cloudera.com/cdh4/one-click-install/#{node[:lsb][:codename]}/amd64/cdh4-repository_1.0_all.deb"
	cdh4keyurl = ""
	  
    curl_proxyconfig = ''
	curl_proxyconfig = "-x #{node['chef_client']['http_proxy']} -U #{node['chef_client']['http_proxy_user']}:#{node['chef_client']['http_proxy_pass']}" unless (node[:chef_client][:http_proxy].nil? || node[:chef_client][:http_proxy_user].nil? || node[:chef_client][:http_proxy_pass].nil?) 

	execute "curl -s #{dpkgurl} #{curl_proxyconfig} > cd4rep.deb ; dpkg -i cd4rep.deb" do
	  #command "echo $PWD ; curl #{dpkgurl} > cd4rep.deb ; dpkg -i cd4rep.deb ; touch /tmp/kk"
	  #not_if "apt-key export 'Cloudera Apt Repository'" 
	  notifies :run, resources("execute[apt-get update]"), :immediately 
	end

end
package "hadoop"
