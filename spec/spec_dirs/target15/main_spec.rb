puts ("==============================")
puts ("Role test")
puts ("openstack_mariadb: #{ ENV['CONN_NAME'] }")
puts ("==============================")

system("cd spec && rm -rf host_vars")
system("cd spec && cp -r host_vars_dirs/host_vars_01 host_vars")
system("cd spec && ansible-playbook -i inventory site.yml")

require 'spec_helper'
file_dir = File.dirname(__FILE__)

describe ("check keystone database is created") do
  describe command("mysql -u root -pp@ssw0rd -e \"show databases;\"") do
    its(:stdout) { should match /\skeystone\s/ }
  end
end

describe ("check permissions for keystone database") do
  describe command("mysql -u root -pp@ssw0rd -e \"show grants for keystone@localhost;\"") do
    its(:stdout) { should match /^\|\sGRANT ALL PRIVILEGES ON `keystone`\.\* TO 'keystone'@'localhost'\s+\|$/ }
  end
  describe command("mysql -u root -pp@ssw0rd -e \"show grants for keystone@'%';\"") do
    its(:stdout) { should match /^\|\sGRANT ALL PRIVILEGES ON `keystone`\.\* TO 'keystone'@'%'\s+\|$/ }
  end
end

