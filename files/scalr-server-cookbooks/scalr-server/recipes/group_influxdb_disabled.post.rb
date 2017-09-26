supervisor_service 'influxdb' do
  description "Stop InfluxDB service"
  action service_is_up?(node, 'influxdb') ? [:stop, :disable] : [:disable]
end
