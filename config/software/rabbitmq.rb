name 'rabbitmq'
default_version '3.6.11'

dependency 'erlang'

source url: "https://www.rabbitmq.com/releases/rabbitmq-server/v#{version}/rabbitmq-server-generic-unix-#{version}.tar.xz"
relative_path "rabbitmq_server-#{version}"

version '3.6.11' do
  source md5: '62dccb5a1bcf8a97450c5796723fe8b9'
end

license 'MPL-2.0'
license_file 'LICENSE'
skip_transitive_dependency_licensing true


build do
  mkdir "#{install_dir}/embedded/lib/rabbitmq/bin"

  # Remove docs
  %w{share INSTALL}.each do |path|
    delete "#{path}"
  end

  sync '.', "#{install_dir}/embedded/lib/rabbitmq/rabbitmq_server-#{version}"

  # Update SYS_PREFIX
  command "sed -ri 's!^(SYS_PREFIX=).*$!\\1#{install_dir}!g' #{install_dir}/embedded/lib/rabbitmq/rabbitmq_server-#{version}/sbin/rabbitmq-defaults"

  # Roughly reproduce debian package structure
  %w{rabbitmqctl rabbitmq-defaults rabbitmq-env rabbitmq-plugins rabbitmq-server}.each do |binary|
    link "#{install_dir}/embedded/lib/rabbitmq/rabbitmq_server-#{version}/sbin/#{binary}", "#{install_dir}/embedded/lib/rabbitmq/bin/#{binary}"
  end

  %w{rabbitmqctl rabbitmq-defaults rabbitmq-env rabbitmq-plugins rabbitmq-server}.each do |binary|
    link "#{install_dir}/embedded/lib/rabbitmq/bin/#{binary}", "#{install_dir}/embedded/bin/#{binary}"
  end

end

