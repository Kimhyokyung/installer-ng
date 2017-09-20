name "libidn"
default_version "1.30"

source url: "http://ftp.gnu.org/gnu/libidn/libidn-#{version}.tar.gz"

version '1.30' do
  source md5: "b17edc8551cd31cc5f14c82a9dabf58e"
end

relative_path "libidn-#{version}"

license 'LGPL-3.0'
license_file 'COPYING.LESSERv3'
skip_transitive_dependency_licensing true


build do
  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure --prefix=#{install_dir}/embedded", env: env
  command "make -j #{workers}", env: env
  command "make install", env: env
end