#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: configure_vm.sh 
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

# - Customization -----------------------------------------------------------

# - End of Customization ----------------------------------------------------

# - Environment Variables ---------------------------------------------------
# - Set default values for environment variables if not yet defined. 
# ---------------------------------------------------------------------------
# Vagrant default stuff
export VAGRANT=${VAGRANT:-/vagrant}
export VAGRANT_RESPONSE=${VAGRANT_RESPONSE:-"${VAGRANT}/response"}
export VAGRANT_SOFTWARE=${VAGRANT_SOFTWARE:-"${VAGRANT}/software"}
export VAGRANT_SCRIPTS=${VAGRANT_SCRIPTS:-"${VAGRANT}/scripts"}

# Trivadis BasEnv
export BASENV_PACKAGE=$(find ${VAGRANT_SOFTWARE} -name "basenv-??.??.final.?.zip"|sort|tail -1)
export DEFAULT_DOMAIN=${DEFAULT_DOMAIN:-"postgasse.org"}

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

# - Upgrade OS --------------------------------------------------------------
echo "-----------------------------------------------------------------------"
echo "   Initiate VM configuration:"
echo "-----------------------------------------------------------------------"

# Setup und configure OS
${VAGRANT_SCRIPTS}/setup_os.sh

# Setup DB binaries
${VAGRANT_SCRIPTS}/setup_db_binaries.sh

# Install Oracle patch set updates
echo " - Install Oracle patch set updates:"

# Install Trivadis toolbox
${VAGRANT_SCRIPTS}/setup_basenv.sh

echo " - Setup Oracle environment:"

echo " - Configure listener:"

echo " - Create Database:"

echo " - Configure example environment:"

echo " - Set Oracle password:";

echo " - Password for SYS and SYSTEM: $ORACLE_PWD";

echo " - Installation complete, database ready to use!";

echo "-----------------------------------------------------------------------"
echo "   Finished configuring VM"
echo "-----------------------------------------------------------------------"

# --- EOF -------------------------------------------------------------------