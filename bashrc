# This bash script can be used by .bashrc or .bash_profile to run SWAY on first login.
if [[ -z "${XDG_RUNTIME_DIR}" ]]; then
  export XDG_RUNTIME_DIR="/tmp/${UID}-runtime-dir";
fi
# Making this simpler in case XDG-run-DIR enviroment variable has its value reset or changed.
if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
  export XDG_RUNTIME_DIR="fail";
else
  echo "XDG runtime directory is working... is sway already running?";
fi
if [[ ${XDG_RUNTIME_DIR} == "fail" ]]; then
  export XDG_RUNTIME_DIR="/tmp/${UID}-runtime-dir";
  mkdir ${XDG_RUNTIME_DIR};
  sway;
fi
