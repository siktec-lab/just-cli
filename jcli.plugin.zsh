# ------------------------------------------------------------------------------
#          FILE:  jcli.plugin.zsh
#   DESCRIPTION:  oh-my-zsh just-cli plugin file.
#        AUTHOR:  Jitendra Adhikari (jiten.adhikary@gmail.com)
#       VERSION:  0.0.1
#       LICENSE:  MIT
# ------------------------------------------------------------------------------
# Specifically tuned to support autocompletion for apps build with siktec/just-cli!
#         Check https://github.com/siktec-lab/just-cli
# ------------------------------------------------------------------------------

# JCli command completion
_jcli_command_list () {
  command $1 --help 2>/dev/null | sed "1,/Commands/d" | gawk 'match($0, /  ([a-z]+) [a-z]*  /, c) { print c[1] }'
}

# JCli option completion
_jcli_option_list () {
  command $1 $2 --help 2>/dev/null | sed '1,/Options/d' | gawk 'match($0, /  .*(--[a-z-]+)(\.\.\.)?.    /, o) { print o[1] }'
}

# JCli compdef handler
_jcli () {
  local curcontext="$curcontext" state line cmd subcmd
  typeset -A opt_args
  _arguments '1: :->cmd' '*: :->opts'

  cmd=`echo $curcontext | gawk 'match($0, /\:([_a-z-]+)\:$/, c) { print c[1] }'`
  subcmd=`echo $line | awk '{print $1}'`

  case $state in
    cmd) compadd $(_jcli_command_list $cmd) ;;
    opts) compadd $(_jcli_option_list $cmd $subcmd) ;;
  esac
}

#
# Register commands for autocompletion below:
#
# format:  compdef _jcli <cmd>
# example: compdef _jcli your-cli-app
#
