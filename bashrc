# This bash script can be used by .bashrc or .bash_profile to run SWAY on first login.
if [[ -z "${XDG_RUNTIME_DIR}" ]]; then
  export XDG_RUNTIME_DIR="1";
else
  if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
    export XDG_RUNTIME_DIR="1";
  else
    echo "XDG runtime directory is working... is sway already running?";
  fi
fi
if [[ ${XDG_RUNTIME_DIR} == "1" ]]; then
  export XDG_RUNTIME_DIR="/tmp/${UID}-runtime-dir";
  mkdir ${XDG_RUNTIME_DIR};
  sway;
fi
