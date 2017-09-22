name 'influxdb'

default_version '1.3.5'

source url: "https://dl.influxdata.com/influxdb/releases/influxdb-#{version}-static_linux_amd64.tar.gz"

version '1.3.5' do
  source md5: '2a28d6793e95d74947a40813ae9dab70'
end

license 'MIT'
skip_transitive_dependency_licensing true


relative_path "influxdb-#{version}-1"

build do
  %w{influxd influx influx_inspect}.each do |binary|
    copy binary, "#{install_dir}/embedded/bin/"
  end
end
