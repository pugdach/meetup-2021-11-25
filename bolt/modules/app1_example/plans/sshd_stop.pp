# Plan to stop sshd on serveral nodes
# first: step1_nodes, then step2_nodes, then step3_nodes
#
# @param step1_nodes Array of nodes to run the first step on
# @param step2_nodes Array of nodes to run the second step on
# @param step3_nodes Array of nodes to run the third step on
#
plan app1_example::sshd_stop (
  TargetSpec $step1_nodes,
  TargetSpec $step2_nodes,
  TargetSpec $step3_nodes,
){
  run_command('puppet resource service sshd ensure=stopped', $step1_nodes)
  run_command('puppet resource service sshd ensure=stopped', $step2_nodes)
  run_command('puppet resource service sshd ensure=stopped', $step3_nodes)
}
