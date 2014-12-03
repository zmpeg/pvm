
function pvm {
  local PVMHOME="$HOME/.pvm"
  local PHPS="$PVMHOME/phps"

  case "$1" in

    update)
      __pvm_install
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

function __pvm_install {
  echo "install..."
}
