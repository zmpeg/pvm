
export PVM_HOME="$HOME/.pvm"
export PVM_PHPS="$PVM_HOME/phps"
export PVM_SOURCE="/home/matt/projects/pvm/pvm.sh"
export PVM_PHP_GIT="https://github.com/php/php-src.git"
export PVM_TMP="$PVM_HOME/.tmp"

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
  mkdir -p "$PVM_TMP"

  cp $PVM_SOURCE $PVM_HOME/pvm.sh
}

function __pvm_install {
  ## Rely on php always starting versions with php-
  VALID_PHPS=`curl -s "https://api.github.com/repos/php/php-src/tags" | grep -Po '"name":.*?[^\\\\]",' | awk '{ print $2 }' | sed -e 's/^"//'  -e 's/",$//' | grep -P php\- | tr '\n' ' '`

  if ! __pvm_check_requirements; then
    echo "Missing Dependency"
    return 1
  fi

  if [ ! "$VALID_PHPS" =~ $1 ]; then
    echo "Unsupported PHP version. Please specify: $VALID_PHPS"
    return 1
  else

    # find the specified version from the list
    INSTALL_VERSION=`echo $VALID_PHPS | tr ' ' '\n' | grep $1`

    # if more than one version, grab the latest non-rc version
    if [ ! `echo $INSTALL_VERSION | wc -l` == 1 ]; then
      INSTALL_VERSION=`echo $INSTALL_VERSION | grep -v RC | head -n 1`
    fi

  fi

  echo "Downloading: $INSTALL_VERSION"
  rm -rf "$PVM_TMP"
  mkdir -p "$PVM_TMP"
  curl -L "https://api.github.com/repos/php/php-src/zipball/$INSTALL_VERSION" -o "$PVM_TMP/$INSTALL_VERSION.zip"
  unzip -d $PVM_TMP "$PVM_TMP/$INSTALL_VERSION.zip" > /dev/null
  rm "$PVM_TMP/$INSTALL_VERSION.zip"
  PVM_COMPILE_DIR=$(ls $PVM_TMP)
  
  echo $PVM_COMPILE_DIR

}

function __pvm_check_requirements {
  DEPS=("autoconf" "automake" "libtool" "re2c" "flex" "bison")
  for DEP in $DEPS
  do
    dpkg -l $DEP > /dev/null 2>&1
    [[ $? == '1' ]] && return 1
  done
  return 0
}
