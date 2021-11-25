# Simple plan to run a task on a set of nodes
# with result check
#
# @param version the version to deploy
# @param stage the stage the server run in
# @param servertype the desired servertype
#
plan app1_example::deploy_app (
  String $version,
  Optional[Enum['prod', 'test', 'dev']] $stage = undef,
  Optional[Enum['webserver', 'appserver', 'dbserver']] $servertype = undef,
  Optional[String] $servers = undef,
){

  unless $servers {
    # validate required entries
    assert_type(Enum['prod', 'test', 'dev'], $stage)
    assert_type(Enum['webserver', 'appserver', 'dbserver'], $servertype)

    # get entries from PuppetDB
    $target_query = "trusted.extensions.stage = '${stage}' and trusted.extensions.servertype = '${servertype}'"
    $target_query_result = puppetdb_query("inventory[certname] { ${target_query} }")

    # filter certnames only
    $target_hosts = $target_query_result.map |$r| { $r["certname"] }
  } else {
    $target_hosts = $servers
  }

  $result = run_task('app1_example::upgrade_app', version => $version, $target_hosts, '_catch_errors' => true)
  unless $result.ok {
    fail("Das Ausfuehren des Updates ist fehlgeschlagen. Informationen: ${result.error_set.names}")
  }
}
