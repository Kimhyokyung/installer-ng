# Create RabbitMQ configuration dir and files
directory etc_dir_for(node, 'rabbitmq') do
  description "Create directory (" + etc_dir_for(node, 'mysql') + ")"
  owner     'root'
  group     'root'
  mode      0755
end

template "#{etc_dir_for node, 'rabbitmq'}/rabbitmq-env.conf" do
  description "Generate RabbitMQ configuration (#{etc_dir_for node, 'rabbitmq'}/rabbitmq-env.conf)"
  source    'rabbitmq/rabbitmq-env.conf.erb'
  owner     'root'
  group     'root'
  mode      0644
  helpers   Scalr::PathHelper
  notifies  :restart, 'supervisor_service[rabbitmq]' if service_is_up?(node, 'rabbitmq')
end

template "#{etc_dir_for node, 'rabbitmq'}/rabbitmq.config" do
  description "Generate RabbitMQ configuration (#{etc_dir_for node, 'rabbitmq'}/rabbitmq.config)"
  source    'rabbitmq/rabbitmq.config.erb'
  owner     'root'
  group     'root'
  mode      0644
  helpers   Scalr::PathHelper
  notifies  :restart, 'supervisor_service[rabbitmq]' if service_is_up?(node, 'rabbitmq')
end

# Generate a self signed cert for rabbitmq, if it doesn't exist yet
execute "rabbitmq_certs" do
  description "Generate SSL certificates for RabbitMQ"
  command   "#{node[:scalr_server][:install_root]}/embedded/bin/openssl" \
            " req -x509 -newkey rsa:4096 -days 9999 -nodes" \
            " -keyout '#{node[:scalr_server][:rabbitmq][:ssl_key_path]}'" \
            " -out '#{node[:scalr_server][:rabbitmq][:ssl_cert_path]}'" \
            " -subj '/C=US/ST=California/L=San Francisco/O=Scalr/CN=#{rabbitmq_host node}'"
  creates   node[:scalr_server][:rabbitmq][:ssl_key_path]
  user      'root'
  action    :run
  notifies  :restart, 'supervisor_service[rabbitmq]' if service_is_up?(node, 'rabbitmq')
end

file node[:scalr_server][:rabbitmq][:ssl_key_path] do
  description "Set permissions on the RabbitMQ certificate key file"
  owner     node[:scalr_server][:rabbitmq][:user]
  group     node[:scalr_server][:rabbitmq][:user]
  mode      0600
end

file node[:scalr_server][:rabbitmq][:ssl_cert_path] do
  description "Set permissions on the RabbitMQ certificate file"
  owner     node[:scalr_server][:rabbitmq][:user]
  group     node[:scalr_server][:rabbitmq][:user]
  mode      0644
end

directory bin_dir_for(node, 'rabbitmq') do
  description "Create directory (#{bin_dir_for node, 'rabbitmq'})"
  owner     'root'
  group     'root'
  mode      0755
end

template "#{bin_dir_for node, 'rabbitmq'}/rabbitmq-entrypoint.sh" do
  description "RabbitMQ wrapper"
  owner     'root'
  group     'root'
  source    'rabbitmq/rabbitmq-entrypoint.sh.erb'
  helpers   Scalr::PathHelper
  mode      0755
  notifies  :restart, 'supervisor_service[rabbitmq]' if service_is_up?(node, 'rabbitmq')
end

# Create rabbitmq data dir
directory data_dir_for(node, 'rabbitmq') do
  description "Create directory (" + data_dir_for(node, 'rabbitmq') + ")"
  owner     node[:scalr_server][:rabbitmq][:user]
  group     node[:scalr_server][:rabbitmq][:user]
  mode      0755
end


# Create RabbitMQ run and log dirs
directory run_dir_for(node, 'rabbitmq') do
  description "Create directory (" + run_dir_for(node, 'rabbitmq') + ")"
  owner     node[:scalr_server][:rabbitmq][:user]
  group     node[:scalr_server][:rabbitmq][:user]
  mode      0755
end

directory log_dir_for(node, 'rabbitmq') do
  description "Create directory (" + log_dir_for(node, 'rabbitmq') + ")"
  owner     node[:scalr_server][:rabbitmq][:user]
  group     node[:scalr_server][:rabbitmq][:user]
  mode      0755
end
