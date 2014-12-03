
export PVM_HOME="$HOME/.pvm"
export PVM_PHPS="$PVM_HOME/phps"
export PVM_SOURCE="/home/matt/projects/pvm/pvm.sh"

function pvm {

  case "$1" in

    update)
      __pvm_update
      ;;

    install)
      __pvm_install $2
      ;;

    *)
      __pvm_usage
      ;;
  esac
}

function __pvm_usage {
  echo "
    Usage: pvm <command>

    Commands:
      usage      show this help screen
      update    install or update pvm
  "
}

function __pvm_update {
  mkdir -p "$PVM_HOME"
  mkdir -p "$PVM_PHPS"

  cp $PVM_SOURCE $PVM_HOME/pvm.sh
}

function __pvm_install {
  local VALID_PHPS="5 5.1 5.2 5.3 5.4 5.5 5.6"
  [[ $VALID_PHPS =~ $1 ]] && echo "Install: $1" || echo "Unsupported PHP version"
}