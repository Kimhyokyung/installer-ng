
# influxdb directories

directory etc_dir_for(node, 'influxdb') do
  description "Create directory (" + etc_dir_for(node, 'influxdb') + ")"
  owner     'root'
  group     'root'
  mode      0755
end

directory run_dir_for(node, 'influxdb') do
  description "Create directory (" + run_dir_for(node, 'influxdb') + ")"
  owner     node[:scalr_server][:influxdb][:user]
  group     node[:scalr_server][:influxdb][:user]
  mode      0755
end

directory data_dir_for(node, 'influxdb') do
  description "Create directory (" + data_dir_for(node, 'influxdb') + ")"
  owner     node[:scalr_server][:influxdb][:user]
  group     node[:scalr_server][:influxdb][:user]
  mode      0755
end

directory log_dir_for(node, 'influxdb') do
  description "Create directory (" + log_dir_for(node, 'influxdb') + ")"
  owner     node[:scalr_server][:influxdb][:user]
  group     node[:scalr_server][:influxdb][:user]
  mode      0755
end


# influxdb configuration

template "#{etc_dir_for node, 'influxdb'}/influxdb.conf" do
  description "Generate influxdb configuration (" + "#{etc_dir_for node, 'influxdb'}/influxdb.conf" + ")"
  source    'influxdb/influxdb.conf.erb'
  owner     'root'
  group     'root'
  mode      0644
  helpers do
    include Scalr::PathHelper
    include Scalr::ServiceHelper
  end
  notifies  :restart, 'supervisor_service[influxdb]' if service_is_up?(node, 'influxdb')
end
