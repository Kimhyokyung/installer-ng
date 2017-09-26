supervisor_service 'influxdb' do
  description     "InfluxDB"
  command         "#{node[:scalr_server][:install_root]}/embedded/bin/influxd" \
                  " -config #{etc_dir_for node, 'influxdb'}/influxdb.conf" \
                  " -pidfile #{run_dir_for node, 'influxdb'}/influxdb.pid"
  stdout_logfile  "#{log_dir_for node, 'supervisor'}/influxdb.log"
  stderr_logfile  "#{log_dir_for node, 'supervisor'}/influxdb.log"
  redirect_stderr false
  autostart       true
  startsecs       3
  action          [:enable, :start]

  subscribes      :restart, 'user[scalr_user]' if service_is_up?(node, 'influxdb')
end

influxdb_admin node[:scalr_server][:influxdb][:scalr_user] do
  description "Create InfluxDB admin user"
  username node[:scalr_server][:influxdb][:scalr_user]
  password node[:scalr_server][:influxdb][:scalr_password]
  auth_username node[:scalr_server][:influxdb][:scalr_user]
  auth_password node[:scalr_server][:influxdb][:scalr_password]
  api_hostname 'localhost'
  api_port node[:scalr_server][:influxdb][:http_bind_port]
  action :create
  notifies  :restart, 'supervisor_service[influxdb]'
end

influxdb_database node[:scalr_server][:influxdb][:database] do
  description "Create InfluxDB scalr database"
  name node[:scalr_server][:influxdb][:database]
  auth_username node[:scalr_server][:influxdb][:scalr_user]
  auth_password node[:scalr_server][:influxdb][:scalr_password]
  api_hostname 'localhost'
  api_port node[:scalr_server][:influxdb][:http_bind_port]
  action :create
end

