override[:java][:jdk_version]                              = '8'
override[:java][:install_flavor]                           = 'oracle'
override[:java][:oracle][:accept_oracle_download_terms]    = true

override['kibana']['version'] = '4'
override['kibana']['kibana4_version'] = '4.4.0'
override['kibana']['url'] = "https://download.elastic.co/kibana/kibana/kibana-4.4.0-linux-x64.tar.gz"
override['kibana']['kibana4_checksum'] = 'a8aeb7c2562c46e26a6841b7c359e90eaf1a7a1964a89466c73002dad022dc43'
override['kibana']['index'] = '.kibana'
override['kibana']['nginx']['basic_auth_username'] = 'sauce'
override['kibana']['nginx']['basic_auth_password'] = 'supersecretsauce'