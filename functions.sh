TOP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PACKAGE_INSTALLER=${PACKAGE_INSTALLER:-""}
PACKAGE_TYPE=${PACKAGE_TYPE:-""}

PACKAGE_TYPES="deb brew"
PLATFORMS="linux darwin"


# Determine Package Installer
if [ -n "$(which apt-get)" ]; then
    PACKAGE_INSTALLER="sudo $(which apt-get) install -y"
    PACKAGE_TYPE="deb"
    PLATFORM="linux"
elif [ "$(uname)" == "Darwin" ]; then
    PACKAGE_INSTALLER="$(which brew) install"
    PACKAGE_TYPE="brew"
    PLATFORM="darwin"
fi

# initialize directory structure
mkdir -p ${DEVELOPMENT_DIRECTORY}
mkdir -p ${WSBOOTSTRAP_STATE_DIR}


function ws_install() {
    local pkg_name=$1
    if [ -d ${TOP}/available/${pkg_name} ] && [ ! -d ${WSBOOTSTRAP_STATE_DIR}/enabled/${pkg_name} ]; then
        # link the package into enabled
        mkdir -p ${WSBOOTSTRAP_STATE_DIR}/enabled
        installed_dir="${WSBOOTSTRAP_STATE_DIR}/enabled/${pkg_name}"
        ln -s ${TOP}/available/${pkg_name} ${installed_dir}

        # install any native dependencies
        if [ -f ${installed_dir}/packages.${PACKAGE_TYPE} ]; then
            cat ${installed_dir}/packages.${PACKAGE_TYPE} | xargs ${PACKAGE_INSTALLER}
        fi
        # call any initialization scripts
        if [ -d ${installed_dir}/init.${PACKAGE_TYPE} ]; then
            for script in $(ls ${installed_dir}/init.${PACKAGE_TYPE}); do
                ${installed_dir}/init.${PACKAGE_TYPE}/${script}
            done
        fi
        if [ -d ${installed_dir}/init.${PLATFORM} ]; then
            for script in $(ls ${installed_dir}/init.${PLATFORM}); do
                ${installed_dir}/init.${PLATFORM}/${script}
            done
        fi
        if [ -d ${installed_dir}/init ]; then
            for script in $(ls ${installed_dir}/init); do
                ${installed_dir}/init/${script}
            done
        fi
        ws_load ${pkg_name}
    fi
}

function ws_installed() {
    ls ${WSBOOTSTRAP_STATE_DIR}/enabled
}

function ws_available() {
    # TODO: indicate which are already installed/disabled
    # indicate availability by platform
    ls ${TOP}/available
}

function ws_load() {
    local pkg_name=$1
    # Source installed applications
    pkg_root="${WSBOOTSTRAP_STATE_DIR}/enabled/${pkg_name}"
    if [ -d "${pkg_root}/source" ]; then
        for f in $(ls ${pkg_root}/source/); do
            source ${pkg_root}/source/${f}
        done
    fi
}

function ws_disable() {
    local pkg_name=$1
    pkg_root="${WSBOOTSTRAP_STATE_DIR}/enabled/${pkg_name}"
    if [ -e "${pkg_root}" ]; then
        rm ${pkg_root}
    fi
}

function ws_update() {
    curl https://raw.githubusercontent.com/clusterfudge/wsbootstrap-installer/master/installer.py | python
}
