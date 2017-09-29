#
# Cookbook:: tomcat
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

#yum install java-1.7.0-openjdk-devel

package 'java-1.7.0-openjdk-devel' do
	action :install
end

#groupadd tomcat
group 'tomcat' do
end

directory '/opt/tomcat'

#useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat
user 'tomcat' do
	manage_home false
	home '/opt/tomcat'
	shell '/bin/nologin'
	group 'tomcat'
end

#wget http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.0.46/bin/apache-tomcat-8.0.46.tar.gz
# TODO : Not desired state
remote_file 'apache-tomcat-8.0.46.tar.gz' do
	source 'http://apache.mirrors.ionfish.org/tomcat/tomcat-8/v8.0.46/bin/apache-tomcat-8.0.46.tar.gz'
	action :create
end

#tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1
# TODO : Not desired state
execute 'tar xvf apache-tomcat-8.0.46.tar.gz -C /opt/tomcat --strip-components=1' 

execute 'chgrp -R tomcat /opt/tomcat'

directory '/opt/tomcat/conf' do
        mode '0070'
end
# TODO : Not desired state
execute 'chmod g+x /opt/tomcat/conf' 
# TODO : Not desired state
execute 'chmod -R g+r /opt/tomcat/conf/*'
execute 'cd /opt/tomcat;chown -R tomcat webapps/ work/ temp/ logs/'

template '/etc/systemd/system/tomcat.service' do
	source 'tomcat.service.erb'
end

# TODO : Not desired state
execute 'systemctl daemon-reload' 

service 'tomcat' do
	action [:enable, :start]
end
