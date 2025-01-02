#!/usr/bin/env zunit

@setup {
  load ../home/.config/functions.zsh
}

@test '_clone__get_full_path git@github.com:Zipstack/unstract.git' {
  run _clone__get_full_path git@github.com:Zipstack/unstract.git
  assert "$state" equals 0
  assert "$output" same_as "$HOME/src/github.com/Zipstack/unstract"
}

@test '_clone__get_full_path ssh://git@ssh.git.eon-cds.de:22222/repos/coorporate_functions/lab/sqlmesh-on-databricks.git' {
  run _clone__get_full_path ssh://git@ssh.git.eon-cds.de:22222/repos/coorporate_functions/lab/sqlmesh-on-databricks.git
  assert "$state" equals 0
  assert "$output" same_as "$HOME/src/git.eon-cds.de/repos/coorporate_functions/lab/sqlmesh-on-databricks"
}

@test '_clone__get_full_path git@ssh.dev.azure.com:v3/odin-finops/odin/odin' {
  run _clone__get_full_path git@ssh.dev.azure.com:v3/odin-finops/odin/odin
  assert $state equals 0
  assert $output same_as "$HOME/src/dev.azure.com/odin-finops/odin/odin"
}

@test '_clone__get_full_path https://github.com/vinta/awesome-python.git' {
  run _clone__get_full_path https://github.com/vinta/awesome-python.git
  assert $state equals 0
  assert $output same_as "$HOME/src/github.com/vinta/awesome-python"
}