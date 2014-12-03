
export PVM_HOME="$HOME/.pvm"
export PVM_PHPS="$PVM_HOME/phps"
export PVM_SOURCE="/home/matt/projects/pvm/pvm.sh"

function pvm {

  case "$1" in

    update)
      __pvm_update
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
