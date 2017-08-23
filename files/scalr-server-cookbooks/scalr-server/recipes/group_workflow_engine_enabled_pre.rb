directory log_dir_for(node, 'service') do
  description "Create directory (" + log_dir_for(node, 'service') + ")"
  owner     node[:scalr_server][:app][:user]
  group     node[:scalr_server][:app][:user]
  mode      0755
end
