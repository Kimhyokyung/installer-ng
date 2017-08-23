supervisor_service 'workflow-engine' do
  description "Stop Workflow Engine service"
  action service_is_up?(node, 'workflow-engine') ? [:stop, :disable] : [:disable]
end
