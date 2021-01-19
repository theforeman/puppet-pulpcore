# @summary Run a pulpcore-manager command
#
# @param command
#   The command to run
#
# @param refreshonly
#   The command should only be run as a refresh mechanism for when a dependent
#   object is changed.
#
# @param unless
#   A test command that checks the state of the target system and restricts
#   when the exec can run.
#
# @param path
#   The path to look for commands.
#
# @param user
#   The user to execute the command.
#
# @param pulp_settings
#   Root directory for static content
#
# @param timeout
#   The command should timeout after so many seconds.
#
# @see exec
define pulpcore::admin(
  String $command = $title,
  Boolean $refreshonly = false,
  Optional[String] $unless = undef,
  Array[Stdlib::Absolutepath] $path = ['/usr/bin'],
  String $user = $pulpcore::user,
  Stdlib::Absolutepath $pulp_settings = $pulpcore::settings_file,
  Optional[Integer[0]] $timeout = undef,
) {
  Concat <| title == 'pulpcore settings' |>
  -> exec { "pulpcore-manager ${command}":
    user        => $user,
    path        => $path,
    environment => ["PULP_SETTINGS=${pulp_settings}"],
    refreshonly => $refreshonly,
    unless      => $unless,
    timeout     => $timeout,
    logoutput   => 'on_failure',
  }
}
