# complex plan to deploy an app on several nodes
#
# @param stage the stage from which to select servers
# @param version the version to deploy
#
plan app1_example::multi_nodes_deploy_app (
  Enum['prod', 'test', 'dev'] $stage,
  String[1] $version,
){
  $webserver_query = "trusted.extensions.pp_environment = '${stage}' and trusted.extensions.pp_role = 'webserver'"
  $webserver_query_result = puppetdb_query("inventory[certname] { ${webserver_query} }")

  $appserver_query = "trusted.extensions.pp_environment = '${stage}' and trusted.extensions.pp_role = 'appserver'"
  $appserver_query_result = puppetdb_query("inventory[certname] { ${appserver_query} }")

  $dbserver_query = "trusted.extensions.pp_environment = '${stage}' and trusted.extensions.pp_role = 'dbserver'"
  $dbserver_query_result = puppetdb_query("inventory[certname] { ${dbserver_query} }")

  $webserver_hosts = $webserver_query_result.map |$r| { $r["certname"] }
  $appserver_hosts = $appserver_query_result.map |$r| { $r["certname"] }
  $dbserver_hosts = $dbserver_query_result.map |$r| { $r["certname"] }

  out::message('Deploy on webservers')
  $webserver_result = run_task( 'app1_example::upgrade_app', 'version' => $version, 'targets' => $webserver_hosts, '_catch_errors' => true )
  unless $webserver_result.ok {
    fail("Das Ausfuehren des Updates auf den Webservern ist fehlgeschlagen. Informationen: ${webserver_result.error_set.names}")
  } else {
    out::message($webserver_result)
  }

  out::message('Deploy on appservers')
  $appserver_result = run_task( 'app1_example::upgrade_app', 'version' => $version, 'targets' => $appserver_hosts, '_catch_errors' => true )
  unless $appserver_result.ok {
    fail("Das Ausfuehren des Updates auf den Appservern ist fehlgeschlagen. Informationen: ${appserver_result.error_set.names}")
  } else {
    out::message($appserver_result)
  }

  out::message('Deploy on DB Servers')
  $dbserver_result = run_task( 'app1_example::upgrade_app', 'version' => $version, 'targets' => $dbserver_hosts, '_catch_errors' => true )
  unless $dbserver_result.ok {
    fail("Das Ausfuehren des Updates auf den Db Servern ist fehlgeschlagen. Informationen: ${dbserver_result.error_set.names}")
  } else {
    out::message($dbserver_result)
  }
}

