property :app, String, name_property: true

action :create do

  package "apt-transport-https"

  apt_repository 'filebeats' do
    uri          'https://packages.elastic.co/beats/apt'
    arch         'amd64'
    distribution 'stable'
    components   ['main']
    key          'https://packages.elastic.co/GPG-KEY-elasticsearch'
  end

  package "filebeat"


  directory "/etc/pki/tls/certs" do
    mode 00744
    action :create
    recursive true
  end

  directory "/var/log/filebeat" do
    mode 00744
    action :create
    recursive true
  end

  cookbook_file "logstash-forwarder.crt" do
    source "logstash-forwarder.crt"
    path "/etc/pki/tls/certs/logstash-forwarder.crt"
    mode "644"
    cookbook "elk"
    action :create
  end

  template "/etc/filebeat/filebeat.yml" do
    source "filebeat.yml.erb"
    mode "644"
    cookbook "elk"
    variables(
      environment: node.chef_environment,
      app: app
    )
    notifies :restart, "service[filebeat]", :delayed
  end

  service "filebeat" do
    action :enable
    supports :status => true, :start => true, :stop => true, :restart => true
  end

end
