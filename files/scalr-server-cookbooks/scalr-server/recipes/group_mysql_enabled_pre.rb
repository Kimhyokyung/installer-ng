# Create MySQL configuration dir and file
directory etc_dir_for(node, 'mysql') do
  description "Create directory (" + etc_dir_for(node, 'mysql') + ")"
  owner     'root'
  group     'root'
  mode      0755
end

template "#{etc_dir_for node, 'mysql'}/my.cnf" do
  description "Generate MySQL configuration (" + "#{etc_dir_for node, 'mysql'}/my.cnf" + ")"
  source    'mysql/my.cnf.erb'
  owner     'root'
  group     'root'
  mode      0644
  helpers(Scalr::PathHelper)
  notifies  :restart, 'supervisor_service[mysql]' if service_is_up?(node, 'mysql')
# TODO - Warn user if MySQL tz != UTC? We default to 00:00 here.
end


# Bootstrap MySQL database
directory "#{data_dir_for node, 'mysql'}" do
  description "Create directory (" + "#{data_dir_for node, 'mysql'}" + ")"
  owner     node[:scalr_server][:mysql][:user]
  group     node[:scalr_server][:mysql][:user]
  mode      0755
end


# Create MySQL run and log dirs
directory run_dir_for(node, 'mysql') do
  description "Create directory (" + run_dir_for(node, 'mysql') + ")"
  owner     node[:scalr_server][:mysql][:user]
  group     node[:scalr_server][:mysql][:user]
  mode      0755
end

directory log_dir_for(node, 'mysql') do
  description "Create directory (" + log_dir_for(node, 'mysql') + ")"
  owner     node[:scalr_server][:mysql][:user]
  group     node[:scalr_server][:mysql][:user]
  mode      0755
end

# Note that this runs at compile time.

execute 'mysql_install_db' do
  description "Import mandatory MySQL databases"
  command "#{node[:scalr_server][:install_root]}/embedded/bin/mysql_install_db" \
          " --defaults-file=#{etc_dir_for node, 'mysql'}/my.cnf" \
          " --basedir=#{node[:scalr_server][:install_root]}/embedded" \
          " --user=#{node[:scalr_server][:mysql][:user]}"
  not_if  { mysql_bootstrapped? node }
end
