$node_name = '192.168.7.10'
$slaves = ['192.168.7.10']

class {
  'base':
  ;
  'hadoop':
	hadoop_slaves => $slaves
  ;
  'spark':
  ;
}

