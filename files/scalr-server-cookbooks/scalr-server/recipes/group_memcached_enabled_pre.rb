bash 'set_memcached_password' do
  code  <<-EOH
  printf "%s" "#{node[:scalr_server][:memcached][:password]}" | /opt/scalr-server/embedded/sbin/saslpasswd2 \
  -a memcached \
  -c #{node[:scalr_server][:memcached][:username]} \
  -u scalr \
  -p
  EOH
end

file "#{node[:scalr_server][:install_root]}/embedded/etc/sasldb2" do
  description "Generating sasldb file for memcached"
  mode    0644  # Needs to be readable by memcached
  action :touch
end

cookbook_file "#{node[:scalr_server][:install_root]}/embedded/lib/sasl2/memcached.conf" do
  description "Generating memcached configuration (" + "#{node[:scalr_server][:install_root]}/embedded/lib/sasl2/memcached.conf" + ")"
  source    'memcached/memcached.conf'
  owner     'root'
  group     'root'
  mode      0644
  notifies  :restart, 'supervisor_service[memcached]' if service_is_up?(node, 'memcached')
end
