name 'libevent'
default_version '2.0.22-stable'

source :url => "http://downloads.sourceforge.net/levent/libevent-#{version}.tar.gz"

version '2.0.22-stable' do
  source :md5 => 'c4c56f986aa985677ca1db89630a2e11'
end

dependency 'openssl'

relative_path "libevent-#{version}"

license 'BSD-3-Clause'
license_file 'LICENSE'
skip_transitive_dependency_licensing true


build do
  env = with_standard_compiler_flags(with_embedded_path)

  command './configure' \
          " --prefix=#{install_dir}/embedded" \
          " --with-openssl=#{install_dir}/embedded" \
          ' --enable-static=no', env: env

  make "-j #{workers}", env: env
  make 'install', env: env

end
