#
# Cookbook Name:: elk
# Recipe:: logstash
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

["/etc/pki/tls/certs","/etc/pki/tls/private"].each do |directory|
  directory "#{directory}" do
    mode 00755
    action :create
    recursive true
  end
end

template '/etc/apt/sources.list.d/logstash.list' do
  source "logstash.list.erb"
  notifies :run, 'execute[apt-get update]', :immediately
end

cookbook_file "logstash-forwarder.crt" do
  path "/etc/pki/tls/certs/logstash-forwarder.crt"
  mode "644"
  cookbook 'elk'
  action :create
end

cookbook_file "logstash-forwarder.key" do
  path "/etc/pki/tls/private/logstash-forwarder.key"
  mode "644"
  cookbook 'elk'
  action :create
end

include_recipe "apt"

package "logstash" do
  action :install
  options '--force-yes'
end

["02-beats-input.conf","11-log-filter.conf","30-elasticsearch-output.conf"].each do |file|
  template "/etc/logstash/conf.d/#{file}" do
    source "#{file}.erb"
    notifies :restart, "service[logstash]" , :delayed
  end
end

service "logstash" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
