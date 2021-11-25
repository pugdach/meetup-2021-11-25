service { 'foo':
  ensure => stopped,
}
# .....
service { 'foo':
  ensure => running,
}

