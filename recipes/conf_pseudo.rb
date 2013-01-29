#
# Cookbook Name:: hadoop
# Recipe:: conf_pseudo 
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

include_recipe "hadoop"

execute "hdfs namenode -format" do
	command "yes | sudo -u hdfs hdfs namenode -format"
	action :nothing
end

puts "hello *********************** "

%w{ hadoop-hdfs-datanode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode  hadoop-yarn-nodemanager hadoop-yarn-resourcemanager }.each do |ss|
   service "#{ss}" do
   	 action [ :start, :enable]
   end
end

execute "start hdfs" do
	%w{ hadoop-hdfs-datanode hadoop-hdfs-namenode hadoop-hdfs-secondarynamenode }.each do |hh|
	   notifies :start, "service[#{hh}]", :immediately
   	   notifies :enable, "service[#{hh}]", :immediately
	end
	action :nothing
end

execute "start yarn" do
    %w{ hadoop-yarn-nodemanager hadoop-yarn-resourcemanager }.each do |yy|
	   notifies :start, resources("service[#{yy}]"), :immediately
   	   notifies :enable, resources("service[#{yy}]"), :immediately
    end
    action :nothing
end

execute "hdfs create tmp" do
	action :nothing
	command "sudo -u hdfs 'hadoop fs -rm -r /tmp ; hadoop fs -mkdir /tmp /tmp/hadoop-yarn-staging /tmp/hadoop-yarn/staging/history/done_intermediate /var/log/hadoop-yarn ; " +
	        "hadoop fs -chmod -R 1777 /tmp /tmp/hadoop-yarn/staging /tmp/hadoop-yarn-staging/history/done_intermediate ; " +
	        "hadoop fs -chown -R mapred:mapred /tmp/hadoop-yarn/staging ; hadoop fs -chown -R yarn:mapred /var/log/hadoop-yarn'"
end

# Cloudera distro has a package with all the built-in configuration for a pseudo-distributed node
package "hadoop-conf-pseudo" do
	
	puts "********** hadoop-conf-pseudo *********"

   if node[:hadoop][:format_namenode] then
   	 notifies :run, "execute[hdfs namenode -format]", :immediately
   end

puts "********** notify 1 *********"


   	 notifies :run, "execute[start hdfs]"

puts "********** notify 1 *********"

   	 notifies :run, "execute[hdfs create tmp]"

puts "********** notify 1 *********"

   	 notifies :run, "execute[start yarn]"
end