describe command('curl http://localhost:8080') do	
		its('stdout') { should match /Tomcat/ }
end

describe package('java-1.7.0-openjdk-devel') do
	it { should be_installed }
end

describe group('tomcat') do
	it { should exist }
end

describe user('tomcat') do
	it { should exist }
	its('group') { should eq 'tomcat' }
	its('shell') { should eq '/bin/nologin' }
end

describe file('/opt/tomcat') do
	it { should exist }
	it { should be_directory }
end

describe file('/opt/tomcat/conf') do
	it { should be_directory }
	its('mode') { should cmp '0070' }
end

[  'webapps' , 'work' , 'logs' , 'temp' ].each do |path|
#%[ webapps work logs temp ].each do |path|
	describe file("/opt/tomcat/#{path}") do
	it { should exist }
	its('owner') { should cmp 'tomcat' }
	end
end
describe service('tomcat') do
	it { should be_installed }
	it { should be_running }
	it { should be_enabled }
end
