require 'spec_helper'

elasticsearch_port = 9200
kibana_port = 5601

describe "Elasticsearch Stack" do
  describe service('elasticsearch') do
  	it { should be_running}
  end
  describe port(elasticsearch_port) do
    it { should be_listening}
  end
  describe file('/usr/local/bin/curator') do
    it { should exist }
end

end

describe "Logstash Stack" do
  describe service('logstash') do
  	it { should be_running}
  end
end

describe "Kibana Stack" do
  describe service('nginx') do
  	it { should be_running}
  end
  describe service('kibana') do
  	it { should be_running}
  end
  describe port(kibana_port) do
    it { should be_listening}
  end
  describe package('unzip') do
    it { should be_installed}
  end
  describe package('vim') do
    it { should be_installed}
  end
end