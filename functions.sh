#!/bin/bash

# TODO: Any SSH'ing will probably have to be done in one instance of a remote shell.

source ./colours.sh
source ./remote_scripts.sh

function introduction
{
    echo
    echo "Hello there!"
    echo "You're about to download a package consisting of a domain's files"
    echo "and database which will be automatically set up and ready to use"
    echo "by you on your local development environment. It's just that easy!"
    echo
    echo "But...there's some stuff you'll need to have to hand:"
    echo "  1) Your remote SSH user's password"
    echo
}

function show_help
{
    # TODO: outline the "core" variables as per the entry point in program.sh.
    echo
    echo "-h  | --help                                  Show guide for this program (what you're seeing now)."
    echo "-d= | --local--dir=         [directory]       Give the script the name of your local project's directory."
    echo "-u= | --local-mysql-user=   [mysql_user]      Give the script your local MySQL username."
    echo "-p= | --local-mysql-pass=   [mysql_pass]      Give the script your local MySQL password."
    echo "-r= | --remote-host=        [ssh_host]        Give the script the remote SSH host."
    echo "-w= | --remote-ssh-user=    [ssh_user]        Give the script the remote SSH username."
    echo "-b= | --remote-domain=      [domain]          Give the script the remote domain you're trying to get."
    echo "-x= | --remote-mysql-user=  [mysql_user]      Give the script the remote MySQL username."
    echo "-y= | --remote-mysql-pass=  [mysql_pass]      Give the script the remote MySQL password."
    echo "-z= | --remote-mysql-db=    [mysql_db]        Give the script the remote MySQL database name."
    echo
}
function details_dump
{
    echo "LOCAL_DIR         = ${LOCAL_DIR}"
    echo "LOCAL_MYSQL_USER  = ${LOCAL_MYSQL_USER}"
    echo "LOCAL_MYSQL_PASS  = ${LOCAL_MYSQL_PASS}"

    echo "REMOTE_HOST       = ${REMOTE_HOST}"
    echo "REMOTE_SSH_USER   = ${REMOTE_SSH_USER}" # Password will have to be entered upon script start bu user.
    echo "REMOTE_MYSQL_USER = ${REMOTE_MYSQL_USER}"
    echo "REMOTE_WEBROOT    = ${REMOTE_WEBROOT}"
    echo "REMOTE_DOMAIN     = ${REMOTE_DOMAIN}"
    echo "REMOTE_MYSQL_PASS = ${REMOTE_MYSQL_PASS}"
    echo "REMOTE_MYSQL_DB   = ${REMOTE_MYSQL_DB}"
}

function auto_setup
{
    echo "-------------"
    echo "Local details"
    echo "-------------"
    # LOCAL_DIR
    read -p "Name of your local project directory: " LOCAL_DIR

    # LOCAL_MYSQL_USER
    # This will need to be re-worked for windows (maybe save a DB dump in LOCAL_DIR)
    read -p "Name of your local MySQL user: " LOCAL_MYSQL_USER
    # LOCAL_MYSQL_PASS
    read -p "Local MySQL password: " LOCAL_MYSQL_PASS
    
    echo

    echo "------------"
    echo "Remote setup"
    echo "------------"

    # REMOTE_HOST
    read -p "Name of the remote SSH host you're trying to connect to (either IP or domain): " REMOTE_HOST
    # REMOTE_SSH_USER
    read -p "Name of the remote SSH user you're trying to connect with: " REMOTE_SSH_USER
    # REMOTE_DOMAIN
    read -p "Name of the remote domain you're trying to get: " REMOTE_DOMAIN
    # REMOTE_MYSQL_USER
    read -p "Name of the remote MySQL user: " REMOTE_MYSQL_USER
    # REMOTE_MYSQL_PASS
    read -p "Password of the remote MySQL user: " REMOTE_MYSQL_PASS
    # REMOTE_MYSQL_DB
    read -p "Name of the remote MySQL database you're trying to get: " REMOTE_MYSQL_DB

    echo
    echo
    echo "DEBUG - After auto:"
    echo
    details_dump
}

function clean_up
{
    remove_temp_package_directory

    unset TEMP_REMOTE_DIR

    unset LOCAL_DIR
    unset LOCAL_MYSQL_USER
    unset LOCAL_MYSQL_PASS

    unset REMOTE_HOST
    unset REMOTE_SSH_USER
    unset REMOTE_WEBROOT
    unset REMOTE_DOMAIN
    unset REMOTE_MYSQL_USER
    unset REMOTE_MYSQL_PASS
    unset REMOTE_MYSQL_DB

    exit
}

# function excode_messages
# {
#     local excode=$? # Get exit code of last ran command
#     local success=$1
#     local failure=$2

#     if [ $? != 0 ]; then
#         echo -e "${RED}Failed to create a temp folder on the server!${NONE}"
#         clean_up
#     else
#         echo 
#     fi
# }

# ====== Remote Operations =======
# Here, only functions that happen 
# on the remote host are declared
# ================================

# Temporary package folder management
#
function create_temp_package_directory
{
    local ssh_user="${REMOTE_SSH_USER}"
    local ssh_host="${REMOTE_HOST}"
    local mkdir_tmp="mkdir ~/permission-test/${TEMP_REMOTE_DIR} || exit $? && exit $?" # TODO: Remember to remove permission-test/ from here and the server
    local response

    echo -e "${YELLOW}Attempting to create a temp folder on the server...${NONE}"

    response=$(ssh "${ssh_user}"@"${ssh_host}" "${mkdir_tmp}")

    if [ $? != 0 ]; then
        echo -e "${RED}Failed to create a temp folder on the server!${NONE}"
    fi

    # Return exit code of the 'ssh' command above. If it's 0, all's well.
    return $?
}

function remove_temp_package_directory
{
    # local temp_directory="~/permission-test/${TEMP_REMOTE_DIR}"  # TODO: Remember to remove permission-test/ from here and the server
    local ssh_user="${REMOTE_SSH_USER}"
    local ssh_host="${REMOTE_HOST}"
    local temp_directory="~/deleteme"  # TODO: Remember to replace this with actual temp directory

    ssh "${ssh_user}"@"${ssh_host}" remote_conditionally_remove_directory "${temp_directory}"
}

#
# ------------------------------------

function run_remote_operations
{
    # Create temporary directory where tar'd package will wait.
    create_temp_package_directory
    if [ $? != 0 ]; then
        echo -e "${RED}Failed to create a temp folder on the server!${NONE}"
        clean_up
    else
        echo -e "${GREEN}Successfully created temp folder!${NONE}"
    fi
}

# ============= Main =============
# Here, only functions that happen 
# on the remote host are declared
# ================================

function main
{
    run_remote_operations
}