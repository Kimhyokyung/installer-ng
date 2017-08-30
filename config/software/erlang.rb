# See https://github.com/rabbitmq/erlang-rpm 

name "erlang"
default_version '20.0'

dependency 'zlib'
dependency 'openssl'

source url: "http://www.erlang.org/download/otp_src_#{version}.tar.gz"
relative_path "otp_src_#{version}"

version '20.0' do
  source md5: '2faed2c3519353e6bc2501ed4d8e6ae7'
end

license 'Apache-2.0'
license_file 'LICENSE.txt'
skip_transitive_dependency_licensing true

build do

  patch source: 'fix-pcre-include.patch'
  patch source: '0001-no-man-and-no-misc.patch'
  patch source: '0002-no-c-sources.patch'
  patch source: '0003-no-erl-sources.patch'

  env = with_standard_compiler_flags(with_embedded_path)

  command "./configure" \
          " --prefix=#{install_dir}/embedded" \
          " --enable-threads" \
          " --enable-smp-support" \
          " --enable-kernel-poll" \
          " --enable-dynamic-ssl-lib" \
          " --disable-builtin-zlib" \
          " --without-common_test" \
          " --without-cosEvent" \
          " --without-cosEventDomain" \
          " --without-cosFileTransfer" \
          " --without-cosNotification" \
          " --without-cosProperty" \
          " --without-cosTime" \
          " --without-cosTransactions" \
          " --without-debugger" \
          " --without-dialyzer" \
          " --without-diameter" \
          " --without-edoc" \
          " --without-et" \
          " --without-erl_docgen" \
          " --without-ic" \
          " --without-jinterface" \
          " --without-megaco" \
          " --without-observer" \
          " --without-odbc" \
          " --without-orber" \
          " --without-ssh" \
          " --without-wx" \
          " --without-javac" \
          ' --without-termcap' \
          " --with-ssl=#{install_dir}/embedded" \
          " --disable-debug" \
          ' --mandir=/tmp' \
          ' --infodir=/tmp', env: env

  make "-j #{workers}", env: env
  make "install", env: env

  delete "#{install_dir}/embedded/lib/erlang/erts-*/man"
  delete "#{install_dir}/embedded/lib/erlang/Install"
  delete "#{install_dir}/embedded/lib/erlang/lib/*/examples"

  %w{ct_run dialyzer typer}.each do |useless_bin|
    if useless_bin != 'typer'
      delete "#{install_dir}/embedded/bin/#{useless_bin}"
    end
    delete "#{install_dir}/embedded/lib/erlang/bin/#{useless_bin}"
    delete "#{install_dir}/embedded/lib/erlang/erts-*/bin/#{useless_bin}"
  end

  %w{erl erlc escript run_erl start to_erl}.each do |identical_bin|
    delete "#{install_dir}/embedded/lib/erlang/bin/#{identical_bin}"
    link "#{install_dir}/embedded/lib/erlang/erts-9.0/bin/#{identical_bin}", "#{install_dir}/embedded/lib/erlang/bin/#{identical_bin}"
  end

end