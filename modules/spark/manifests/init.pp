class spark(
  $spark_version = "1.5.0",
  $hdfs_path = "hdfs://${fqdn}:9000/eventlog",
  $spark_driver_memory = "256m",
  $hadoop_conf_dir = "/opt/hadoop-2.6.0/etc/hadoop"
) {

  $spark_home = "/opt/spark"
  $spark_file = "spark-${spark_version}-bin-hadoop2.6"
  $spark_tarball = "${spark_file}.tgz"
  $spark_conf_dir = "${spark_home}/conf"
  $spark_logs_basedir = "$spark_home/logs"

  file { 
    ["${spark_logs_basedir}", "${spark_conf_dir}", "/tmp/spark-events"]:
      ensure => "directory",
      require => Exec["unpack_spark"]
    ;
    "/etc/profile.d/sparkEnv.sh":
      content => template("spark/sparkrc.erb"),
      mode => 755,
      owner => root,
      group => root,
    ;

    "${spark_conf_dir}/log4j.properties":
	  source => "puppet:///modules/spark/log4j.properties",
      mode => 644,
      owner => root,
      group => root,
      require => File["${spark_conf_dir}"]
    ;

    "${spark_conf_dir}/spark-defaults.conf":
      content => template("spark/spark-defaults.conf.erb"),
      mode => 644,
      owner => root,
      group => root,
      require => File["${spark_conf_dir}"]
    ;

    "${spark_conf_dir}/slaves":
      content => template("spark/slaves.erb"),
      mode => 644,
      owner => root,
      group => root,
      require => File["${spark_conf_dir}"]
    ;

    "${spark_conf_dir}/spark-env.sh":
      content => template("spark/spark-env.sh.erb"),
      mode => 755,
      owner => root,
      group => root,
      require => File["${spark_conf_dir}"]
    ;

    "/etc/init/spark-master.conf":
      content => template("spark/spark-master.conf.erb"),
      mode => 755,
      owner => root,
      group => root,
    ;
    "/etc/init/spark-slave.conf":
      content => template("spark/spark-slave.conf.erb"),
      mode => 755,
      owner => root,
      group => root,
    ;
    "/etc/init.d/spark-master":
      ensure => 'link',
      target => '/etc/init/spark-master.conf',
      require => File["/etc/init/spark-master.conf"]
    ;
    "/etc/init.d/spark-slave":
      ensure => 'link',
      target => '/etc/init/spark-slave.conf',
      require => File["/etc/init/spark-slave.conf"]
    ;
  }

  exec { "download_spark":
    command => "wget http://ftp.cixug.es/apache/spark/spark-${spark_version}/${spark_tarball} -O /vagrant/$spark_tarball --read-timeout=5 --tries=0",
    timeout => 1800,
    path => $path,
    creates => "/vagrant/$spark_tarball",
  }

  exec { "unpack_spark" :
    command => "tar -zxvf /vagrant/${spark_tarball} -C /opt && mv /opt/$spark_file ${spark_home}",
    path => $path,
    creates => "${spark_home}",
    require => Exec["download_spark"]
  }

}
