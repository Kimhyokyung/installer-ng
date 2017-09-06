supervisor_service 'rabbitmq' do
  description "Disable RabbitMQ"
  action service_is_up?(node, 'rabbitmq') ? [:stop, :disable] : [:disable]
end
