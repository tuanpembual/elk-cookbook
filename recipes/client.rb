#
# Cookbook Name:: elk
# Recipe:: client
# Do install filebeat
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'elk'

elk_filebeat 'syslog'