#!/bin/bash
# -----------------------------------------------------------------------------
# Trivadis AG, Infrastructure Managed Services
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------------
# Name.......: setup_os.sh 
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.04.11
# Revision...:  
# Purpose....: Script to setup and configure OS
# Notes......: The script does update the OS using yum upgrade, install 
#              additional packages for Oracle and configure the oracle user
#              and groups. Configuration parameter are taken from the
#              environment.
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

# Oracle Software, Patchs and common environment variables
export ORACLE_ROOT=${ORACLE_ROOT:-/u00}
export ORACLE_DATA=${ORACLE_DATA:-/u01}
export ORACLE_BASE=${ORACLE_BASE:-${ORACLE_ROOT}/app/oracle}
export ORACLE_LOCAL=${ORACLE_LOCAL:-${ORACLE_BASE}/local}

# - EOF Environment Variables -------------------------------------------

# - Upgrade OS --------------------------------------------------------------
echo " - Setup OS -----------------------------------------------------------"
# get up to date
echo "%_install_langs   en" >/etc/rpm/macros.lang
yum upgrade -y

echo " - System updated"

# fix locale warning
yum reinstall -y glibc-common
echo LANG=en_US.utf-8 >> /etc/environment
echo LC_ALL=en_US.utf-8 >> /etc/environment
echo " - Locale set"

# - Create Oracle user and groups -------------------------------------------
# - create group oracle and oinstall
# - create user oracle
# - setup subdirectory to install oracle and basenv
# - adjust owner ship of download folder
echo "-----------------------------------------------------------------------"
echo " - Create Oracle user and groups..."

groupadd --gid 1010 oinstall
groupadd --gid 1020 osdba
groupadd --gid 1030 osoper
groupadd --gid 1040 osbackupdba
groupadd --gid 1050 oskmdba
groupadd --gid 1060 osdgdba
groupadd --gid 1070 osracdba

useradd --create-home --gid oinstall --groups osdba,osoper,osbackupdba,osdgdba,oskmdba,osracdba \
        --shell /bin/bash oracle

# Install Oracle Database prereq and openssl packages
echo " - Install Oracle Database prereq packages..."
yum install -y oracle-database-preinstall-18c openssl perl perl-core

# TODO: create oracle vg
echo " - Create Oracle directories:"
install --owner oracle --group oinstall --mode=775 --verbose --directory \
    ${ORACLE_ROOT} \
    ${ORACLE_BASE} \
    ${ORACLE_BASE}/product \
    ${ORACLE_LOCAL} \
    ${ORACLE_ROOT}/oradata \
    ${ORACLE_DATA}/oradata

echo " - Finished setup OS --------------------------------------------------"
# --- EOF -------------------------------------------------------------------