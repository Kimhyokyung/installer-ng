supervisor_service 'rabbitmq' do
  description     "RabbitMQ service"
  command         "#{bin_dir_for node, 'rabbitmq'}/rabbitmq-entrypoint.sh"
  stdout_logfile  "#{log_dir_for node, 'supervisor'}/rabbitmq.log"
  stderr_logfile  "#{log_dir_for node, 'supervisor'}/rabbitmq.err"
  user            node[:scalr_server][:rabbitmq][:user]
  environment     'HOME' => data_dir_for(node, 'rabbitmq'), 'PATH' => scalr_exec_path(node)
  autostart       true
  startsecs       10
  action          [:enable, :start]
  subscribes      :restart, 'user[rabbitmq_user]' if service_is_up?(node, 'rabbitmq')
end

rabbitmq_plugin 'rabbitmq_management' do
  description     "Enable RabbitMQ Management plugin"
  action          :enable
end

rabbitmq_user node[:scalr_server][:rabbitmq][:scalr_user] do
  description     "Create RabbitMQ scalr user"
  password        node[:scalr_server][:rabbitmq][:scalr_password]
  tag             'administrator'
  permissions     '.* .* .*'
  action          [:add, :set_tags, :set_permissions]
end

rabbitmq_user 'guest' do
  description     "Delete RabbitMQ default user"
  action          :delete
end
