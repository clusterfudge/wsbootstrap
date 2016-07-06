if [ -L ~/.bashrc ]; then
  TOP="$( cd "$( dirname $(readlink "${BASH_SOURCE[0]}"))" && pwd )"
else
  TOP="$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd )"
fi

#################################
# wsbootstrap entry point
# 
#
#
#################################
source ${TOP}/defaults.sh
source ${TOP}/functions.sh


# ensure bootstrap scripts are enabled
ws_install bootstrap

# load enabled packages
for pkg_name in $(ls ${TOP}/enabled/); do
	ws_load ${pkg_name}
done
