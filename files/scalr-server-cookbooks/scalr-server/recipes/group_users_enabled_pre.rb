user 'memcached_user' do
  description "Create Linux user (" + node[:scalr_server][:memcached][:user] + ")"
  username  node[:scalr_server][:memcached][:user]
  home      etc_dir_for(node, 'memcached')
  system    true
  notifies  :restart, 'supervisor_service[memcached]' if service_is_up?(node, 'memcached')
end

group 'memcached_group' do
  description "Create Linux group (" + node[:scalr_server][:memcached][:user] + ")"
  group_name node[:scalr_server][:memcached][:user]
  members   [ node[:scalr_server][:memcached][:user] ]
end

user 'scalr_user' do
  description "Create Linux user (" + node[:scalr_server][:app][:user] + ")"
  username  node[:scalr_server][:app][:user]
  home      "#{node[:scalr_server][:install_root]}/embedded/scalr"
  shell     '/bin/sh'  # TODO - Needed?
  system    true
end

group 'scalr_group' do
  description "Create Linux group (" + node[:scalr_server][:app][:user] + ")"
  group_name node[:scalr_server][:app][:user]
  members   [ node[:scalr_server][:app][:user] ]
end

user 'mysql_user' do
  description "Create Linux user (" + node[:scalr_server][:mysql][:user] + ")"
  username  node[:scalr_server][:mysql][:user]
  home      data_dir_for(node, 'mysql')  # TODO - Check if this works when it doesn't exist.
  system    true
end

group 'mysql_group' do
  description "Create Linux group (" + node[:scalr_server][:mysql][:user] + ")"
  group_name node[:scalr_server][:mysql][:user]
  members   [ node[:scalr_server][:mysql][:user] ]
end

user 'rabbitmq_user' do
  description "Create Linux user (" + node[:scalr_server][:rabbitmq][:user] + ")"
  username  node[:scalr_server][:rabbitmq][:user]
  home      data_dir_for(node, 'rabbitmq')  # TODO - Check if this works when it doesn't exist.
  system    true
end

group 'rabbitmq_group' do
  description "Create Linux group (" + node[:scalr_server][:rabbitmq][:user] + ")"
  group_name node[:scalr_server][:rabbitmq][:user]
  members   [ node[:scalr_server][:rabbitmq][:user] ]
end
