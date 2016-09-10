#
# Cookbook Name:: elk
# Recipe:: elasticsearch
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'json'
include_recipe "apt"
include_recipe "java"
include_recipe "python"

elasticsearch_user 'elasticsearch'
elasticsearch_install 'elasticsearch'

elasticsearch_configure 'elasticsearch' do
  configuration(
    "network.host" => "localhost"
  )
end

elasticsearch_service "elasticsearch" do
  service_actions [:enable, :start]
end

## add cron for maintance indices
python_pip 'elasticsearch-curator'

cron 'curator' do
  hour '10'
  minute '0'
  weekday '2'
  command "/usr/local/bin/curator --host 127.0.0.1 delete indices --older-than 30 --time-unit days --timestring '%Y.%m.%d'"
end
