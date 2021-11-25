# plan to deploy an app on a single server type
#
# @param version the version to deploy
# @param servertype the server type to select
# @param stage the stage toselect servers from
#
plan app1_example::single_instance_deploy_app (
  String $version,
  Enum['prod', 'test', 'dev'] $stage,
  Enum['webserver', 'appserver', 'dbserver'] $servertype
){
  $target_query = "trusted.extensions.stage = '${stage}' and trusted.extensions.servertype = '${servertype}'"
  $target_query_result = puppetdb_query("inventory[certname] { ${target_query} }")

  $target_hosts = $target_query_result.map |$r| { $r["certname"] }

  run_task('app1_example::upgrade_app', version => $version, $target_hosts)
}
