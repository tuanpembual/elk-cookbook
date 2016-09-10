#
# Cookbook Name:: elk
# Recipe:: kibana
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe "kibana::kibana4"
include_recipe "kibana::nginx"

["kibana","nginx"].each do |program|
  service "#{program}" do
    action [:enable, :start]
    supports :start => true, :enable => true, :restart => true, :stop => true
  end
end

file "/etc/nginx/sites-enabled/kibana" do
  action :delete
end

template "/etc/nginx/sites-available/default" do
  source "nginx.conf.erb"
end

package ["unzip","vim","apache2-utils"] do
  action :install
  options '--force-yes'
end

service "kibana" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable ]
end

execute 'kibana_symlink' do
  command 'sudo ln -s /opt/kibana/current/bin/kibana /usr/sbin/kibana'
  not_if { File.exist?("/usr/sbin/kibana") }
end

# danger here
username = node['kibana']['nginx']['basic_auth_username']
password = node['kibana']['nginx']['basic_auth_password']

bash 'install template' do
  cwd '/tmp'
  code <<-EOH
  htpasswd -bmc /etc/nginx/htpasswd.users #{username} #{password}
  rm -rf beats-dashboards-1.1.0.zip
  wget https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip
  wget https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json
  unzip beats-dashboards-1.1.0.zip
  cd beats-dashboards-1.1.0 && ./load.sh
  curl -XPUT "http://localhost:9200/_template/filebeat?pretty" -d@filebeat-index-template.json
  EOH
end

execute 'kibana_start' do
  command 'sudo service kibana restart'
  notifies :restart, "service[nginx]", :delayed
end