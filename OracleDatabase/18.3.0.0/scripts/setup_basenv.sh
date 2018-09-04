#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: setup_basenv.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.04.11
# Revision...:  
# Purpose....: Script to install and setup Trivadis BasEnv
# Notes......: The script does install Trivadis BasEnv from the local vagrant
#              software folder. Configuration parameter are taken from the
#              environment.
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

# Trivadis BasEnv
export BASENV_PACKAGE=$(find ${VAGRANT_SOFTWARE} -name "basenv-??.??.final.?.zip"|sort|tail -1)
export DEFAULT_DOMAIN=${DEFAULT_DOMAIN:-"postgasse.org"}

# Oracle Software, Patchs and common environment variables
export ORACLE_ROOT=${ORACLE_ROOT:-/u00}
export ORACLE_BASE=${ORACLE_BASE:-${ORACLE_ROOT}/app/oracle}
export ORACLE_LOCAL=${ORACLE_LOCAL:-${ORACLE_BASE}/local}
export ORACLE_HOME_NAME=${ORACLE_HOME_NAME:-"18.3.0.0"}
export ORACLE_HOME=${ORACLE_BASE}/product/${ORACLE_HOME_NAME}
export ORACLE_EDITION=${ORACLE_EDITION:-"EE"}
export TNS_ADMIN=${TNS_ADMIN:-${ORACLE_BASE}/network/admin}
# - EOF Environment Variables -------------------------------------------


echo " - Install Trivadis toolbox -------------------------------------------"
if [ -s "${BASENV_PACKAGE}" ]; then
    cp ${VAGRANT_RESPONSE}/base_install.rsp.tpl ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###ORACLE_BASE###|${ORACLE_BASE}|g" ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###ORACLE_HOME###|${ORACLE_HOME}|g" ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###TNS_ADMIN###|${TNS_ADMIN}|g" ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###ORACLE_LOCAL###|${ORACLE_LOCAL}|g" ${VAGRANT_RESPONSE}/base_install.rsp
    sed -i -e "s|###DEFAULT_DOMAIN###|${DEFAULT_DOMAIN}|g" ${VAGRANT_RESPONSE}/base_install.rsp

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

echo " - Finished installing Trivadis toolbox -------------------------------"
# --- EOF -------------------------------------------------------------------