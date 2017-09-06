
default['rabbitmq']['user_home'] = '/var/lib/rabbitmq'
default['rabbitmq']['erlang_cookie_path'] = "#{node.rabbitmq.user_home}/.erlang.cookie"
