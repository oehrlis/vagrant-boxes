#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: setup_db_binaries.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.04.11
# Revision...:  
# Purpose....: Script to download and install latest version of oudbase
# Notes......: The script does download the latest version of OUD Base from
#              GitHub and install it in ${ORACLE_BASE}
# Reference..: --
# License....: Licensed under the Universal Permissive License v 1.0 as 
#              shown at http://oss.oracle.com/licenses/upl.
# -----------------------------------------------------------------------------
# Modified...:
# see git revision history for more information on changes/updates
# -----------------------------------------------------------------------------

# - Environment Variables ---------------------------------------------------
# - Set default values for environment variables if not yet defined. 
# ---------------------------------------------------------------------------
# Vagrant default stuff
export VAGRANT=${VAGRANT:-/vagrant}
export VAGRANT_RESPONSE=${VAGRANT_RESPONSE:-"${VAGRANT}/response"}
export VAGRANT_SOFTWARE=${VAGRANT_SOFTWARE:-"${VAGRANT}/software"}

# Oracle Software, Patchs and common environment variables
export ORACLE_ROOT=${ORACLE_ROOT:-/u00}
export ORACLE_DATA=${ORACLE_DATA:-/u01}
export ORACLE_BASE=${ORACLE_BASE:-${ORACLE_ROOT}/app/oracle}
export ORACLE_LOCAL=${ORACLE_LOCAL:-${ORACLE_BASE}/local}
export ORACLE_EDITION=${ORACLE_EDITION:-"EE"}
export TNS_ADMIN=${TNS_ADMIN:-${ORACLE_BASE}/network/admin}
export ORACLE_PACKAGE="${VAGRANT_SOFTWARE}/LINUX.X64_180000_db_home.zip"
export ORACLE_EXAMPLES_PACKAGE="${VAGRANT_SOFTWARE}/LINUX.X64_180000_examples.zip"
export ORACLE_HOME_NAME=${ORACLE_HOME_NAME:-"18.3.0.0"}
export ORACLE_HOME=${ORACLE_BASE}/product/${ORACLE_HOME_NAME}

# - EOF Environment Variables -------------------------------------------

echo " - Install Oracle DB binaries -----------------------------------------"
if [ -s "${ORACLE_PACKAGE}" ]; then
    mkdir -p ${ORACLE_HOME}
    chown oracle:oinstall -R ${ORACLE_ROOT}/app
    unzip -o ${ORACLE_PACKAGE} -d ${ORACLE_HOME}/
    cp ${VAGRANT_RESPONSE}/db_install.rsp.tpl ${VAGRANT_RESPONSE}/db_install.rsp
    sed -i -e "s|###ORACLE_ROOT###|$ORACLE_ROOT|g" ${VAGRANT_RESPONSE}/db_install.rsp
    sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" ${VAGRANT_RESPONSE}/db_install.rsp
    sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" ${VAGRANT_RESPONSE}/db_install.rsp
    sed -i -e "s|###ORACLE_EDITION###|$ORACLE_EDITION|g" ${VAGRANT_RESPONSE}/db_install.rsp

    su -l oracle -c "yes | $ORACLE_HOME/runInstaller -silent -ignorePrereqFailure -waitforcompletion -responseFile ${VAGRANT_RESPONSE}/db_install.rsp"
    ${ORACLE_ROOT}/app/oraInventory/orainstRoot.sh
    $ORACLE_HOME/root.sh
    rm -rf ${VAGRANT_RESPONSE}/db_install.rsp
else
     # TODO: add support for download oracle binary
    echo " - Can not find oracle binary package, skip Oracle installation"
fi

echo " - Install Oracle examples:"
if [ -s "${ORACLE_EXAMPLES_PACKAGE}" ]; then
    unzip -o ${ORACLE_EXAMPLES_PACKAGE} -d ${VAGRANT_SOFTWARE}
    cp ${VAGRANT_RESPONSE}/demos_install.rsp.tpl ${VAGRANT_RESPONSE}/demos_install.rsp
    sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" ${VAGRANT_RESPONSE}/demos_install.rsp
    sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" ${VAGRANT_RESPONSE}/demos_install.rsp
    
    su -l oracle -c "yes | ${VAGRANT_SOFTWARE}/examples/runInstaller -silent -ignorePrereqFailure -waitforcompletion -responseFile ${VAGRANT_RESPONSE}/demos_install.rsp"
    $ORACLE_HOME/root.sh
    rm -rf ${VAGRANT_SOFTWARE}/examples
    rm -rf ${VAGRANT_RESPONSE}/demos_install.rsp
else
     # TODO: add support for download oracle binary
    echo " - Can not find oracle binary package, skip Oracle installation"
fi

echo " - Install Oracle patch set updates:"

echo " - Install Trivadis toolbox:"
if [ -s "${BASENV_PACKAGE}" ]; then
    cp ${VAGRANT_RESPONSE}/base_install.rsp.tpl ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###ORACLE_BASE###|${ORACLE_BASE}|g" ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###ORACLE_HOME###|${ORACLE_HOME}|g" ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###TNS_ADMIN###|${TNS_ADMIN}|g" ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###ORACLE_LOCAL###|${ORACLE_LOCAL}|g" ${VAGRANT_RESPONSE}/base_install.rsp

    # create softlink for oratab
    mv -rf /etc/oratab ${ORACLE_BASE}/etc/oratab
    touch ${ORACLE_BASE}/etc/oratab
    ln -sf ${ORACLE_BASE}/etc/oratab /etc/oratab
    
    su -l oracle -c "unzip -o $BASENV_PACKAGE -d ${ORACLE_LOCAL}"
    su -l oracle -c "${ORACLE_LOCAL}/runInstaller -responseFile ${VAGRANT_RESPONSE}/base_install.rsp -silent"
    rm -rf ${ORACLE_LOCAL}/basenv-* ${ORACLE_LOCAL}/runInstaller*
    rm -rf ${VAGRANT_RESPONSE}/base_install.rsp
else
    # TODO: add support for download basenv
    echo " - Can not find basenv package, skip Trivadis toolbox installation"
fi

echo " - Finished installing Oracle DB binaries -----------------------------"

# --- EOF -------------------------------------------------------------------