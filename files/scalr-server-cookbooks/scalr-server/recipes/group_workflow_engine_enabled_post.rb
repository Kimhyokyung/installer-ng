supervisor_service 'workflow-engine' do
  description     "Workflow Engine"
  command         "#{node[:scalr_server][:install_root]}/embedded/bin/celery" \
                  ' worker' \
                  ' -Q server' \
                  ' -A server.apps.server' \
                  ' -n workflow-engine-%(process_num)s' \
                  ' -l INFO' \
                  ' -P gevent' \
                  ' --without-gossip' \
                  ' --without-heartbeat' \
                  ' --without-mingle'
  stdout_logfile  "#{node[:scalr_server][:install_root]}/var/log/service/workflow-engine.log"
  stderr_logfile  "#{node[:scalr_server][:install_root]}/var/log/service/workflow-engine.err"
  environment     'PYTHONPATH' => "#{node[:scalr_server][:install_root]}/embedded/scalr/app/python/fatmouse"
  redirect_stderr true
  autostart       true
  startsecs       10
  action          [:enable, :start]
  subscribes      :restart, 'file[scalr_config]' if service_is_up?(node, 'workflow-engine')
  subscribes      :restart, 'file[scalr_code]' if service_is_up?(node, 'workflow-engine')
  subscribes      :restart, 'file[scalr_cryptokey]' if service_is_up?(node, 'workflow-engine')
  subscribes      :restart, 'file[scalr_id]' if service_is_up?(node, 'workflow-engine')
  subscribes      :restart, 'user[scalr_user]' if service_is_up?(node, 'workflow-engine')
end
