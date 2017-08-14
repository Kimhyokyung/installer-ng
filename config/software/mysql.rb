# I need perl for the scripts here

name 'mysql'
default_version '5.6.33'

source :url => "http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-#{version}.tar.gz"

version '5.6.22' do
  source :md5 => '3985b634294482363f3d87e0d67f2262'
end

version '5.6.24' do
  source :md5 => '68e1911f70eb1b02170d4f96bf0f0f88'
end

version '5.6.33' do
  source :md5 => '7fbf37928ef651e005b80e820a055385'
end

dependency 'zlib'
dependency 'ncurses'
dependency 'libedit'
dependency 'openssl'
dependency 'libaio'

relative_path "mysql-#{version}"

license 'GPL-2.0'
license_file 'COPYING'
skip_transitive_dependency_licensing true


# View: http://dev.mysql.com/doc/refman/5.5/en/source-configuration-options.html

# TODO - Check --enable-languages (mysqlbug)
build do
  env = with_standard_compiler_flags(with_embedded_path)

  command [
              'cmake',
              # General flags
              '-DCMAKE_SKIP_RPATH=YES',
              "-DCMAKE_INSTALL_PREFIX=#{install_dir}/embedded",
              # Do not create a scripts directory just for mysql
              "-DINSTALL_SCRIPTDIR=#{install_dir}/embedded/bin",
              # Additional Paths flag. We kindly ask MySQL not to drop everything in ./embedded
              '-DINSTALL_DOCREADMEDIR=/tmp',
              '-DINSTALL_INFODIR=/tmp',
              '-DINSTALL_MYSQLTESTDIR=/tmp',
              '-DINSTALL_INFODIR=/tmp',
              '-DINSTALL_DOCDIR=/tmp',
              '-DINSTALL_MANDIR=/tmp',
              '-DINSTALL_SQLBENCHDIR=/tmp',
              # Build type
              '-DBUILD_CONFIG=mysql_release',
              # Don't build embedded server libraries (we don't use those, and they are *huge*)
              '-DWITH_EMBEDDED_SERVER=0',
              # We don't need NDB
              '-DWITH_NDBCLUSTER=OFF',
              '-DWITH_NDBCLUSTER_STORAGE_ENGINE=OFF',
              # Lib flags
              '-DWITH_ZLIB=system',
              '-DWITH_SSL=system',
              '-DWITH_EDITLINE=system',
              # Feature flags
              '-DDEFAULT_CHARSET=utf8',
              '-DDEFAULT_COLLATION=utf8_unicode_ci',
              # MySQL runtime options. We set those to reasonable defaults that are used in the cookbook
              "-DMYSQL_UNIX_ADDR=#{install_dir}/var/run/mysql/mysql.sock",
              "-DSYSCONFDIR=#{install_dir}/etc/mysql",
              '.',
          ].join(' '), :env => env

  make "-j #{workers}", env: env
  make "-j #{workers} install", env: env

  # Move perl script away and install the bash script instead to remove dependency on Perl
  move "#{install_dir}/embedded/bin/mysql_install_db", "#{install_dir}/embedded/bin/mysql_install_db.pl"
  # Install bash script instead
  copy 'scripts/mysql_install_db.sh', "#{install_dir}/embedded/bin/mysql_install_db"

  delete "#{install_dir}/embedded/data"

end
