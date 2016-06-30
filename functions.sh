TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGE_INSTALLER=${PACKAGE_INSTALLER:-""}
PACKAGE_TYPE=${PACKAGE_TYPE:-""}


# Determine Package Installer
if [ -n $(which apt-get) ]; then
    PACKAGE_INSTALLER="sudo $(which apt-get) install -y"
    PACKAGE_TYPE="deb"
elif [ -n $(which brew) ]; then
    PACKAGE_INSTALLER="$(which brew) install"
    PACKAGE_TYPE="brew"
fi



function ws_install() {
    local pkg_name=$1
    if [ -d ${TOP}/available/${pkg_name} ] && [ ! -d ${TOP}/enabled/${pkg_name} ]; then
        # link the package into enabled
        installed_dir="${TOP}/enabled/${pkg_name}"
        ln -s ${TOP}/available/${pkg_name} ${installed_dir}

        # install any native dependencies
        if [ -f ${installed_dir}/packages.${PACKAGE_TYPE} ]; then
            cat ${installed_dir}/packages.${PACKAGE_TYPE} | xargs ${PACKAGE_INSTALLER}
        fi
        # call any initialization scripts
        if [ -d ${installed_dir}/init ]; then
            echo "Initializing the ${pkg_name} package."
            for script in $(ls ${installed_dir}/init); do
                ${installed_dir}/init/${script}
            done
        fi
    fi
}

function ws_load() {
    local pkg_name=$1
    # Source installed applications
    pkg_root="${TOP}/enabled/${pkg_name}"
    if [ -d "${pkg_root}/source" ]; then
        for f in $(ls ${pkg_root}/source/); do
            source ${pkg_root}/source/${f}
        done
    fi
}
