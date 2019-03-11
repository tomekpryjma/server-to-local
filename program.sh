#!/bin/bash

set -o errexit
set -o nounset

# Default Globals
LOCAL_DIR=''
LOCAL_MYSQL_USER=''
LOCAL_MYSQL_PASS=''

REMOTE_HOST=''
REMOTE_SSH_USER='' # Password will have to be entered upon script start bu user.
REMOTE_MYSQL_USER=''
REMOTE_MYSQL_PASS=''
REMOTE_MYSQL_DB=''

function clean_up
{
    unset LOCAL_DIR
    unset LOCAL_MYSQL_USER
    unset LOCAL_MYSQL_PASS

    unset REMOTE_HOST
    unset REMOTE_SSH_USER
    unset REMOTE_MYSQL_USER
    unset REMOTE_MYSQL_PASS
    unset REMOTE_MYSQL_DB
}

# Run
if [ "$#" -eq 0 ]; then
        printf 'This script needs options to be parsed into it.'
        echo
        printf 'Type '"\"${0##*/} -h\""
        printf ' to get all available options.'
    else

    for i in "$@"
    do
        case $i in

            # Localhost globals
            -d=*|--local-dir=*)
                LOCAL_DIR="${i#*=}"
                shift
                ;;
                
            -u=*|--local-mysql-user=*)
                LOCAL_MYSQL_USER="${i#*=}"
                shift
                ;;

            -p=*|--local-mysql-pass=*)
                LOCAL_MYSQL_PASS="${i#*=}"
                shift
                ;;

            # Remote globals
            -h=*|--remote-host=*)
                REMOTE_HOST="${i#*=}"
                shift
                ;;

            -w=*|--remote-ssh-user=*)
                REMOTE_SSH_USER="${i#*=}"
                shift
                ;;

            -x=*|--remote-mysql-user=*)
                REMOTE_MYSQL_USER="${i#*=}"
                shift
                ;;

            -y=*|--remote-mysql-pass=*)
                REMOTE_MYSQL_PASS="${i#*=}"
                shift
                ;;

            -z=*|--remote-mysql-db=*)
                REMOTE_MYSQL_DB="${i#*=}"
                shift
                ;;
            
            # Unknown value
            *)
                ;;


        esac
    done

    echo "LOCAL_DIR         = ${LOCAL_DIR}"
    echo "LOCAL_MYSQL_USER  = ${LOCAL_MYSQL_USER}"
    echo "LOCAL_MYSQL_PASS  = ${LOCAL_MYSQL_PASS}"

    echo "REMOTE_HOST       = ${REMOTE_HOST}"
    echo "REMOTE_SSH_USER   = ${REMOTE_SSH_USER}" # Password will have to be entered upon script start bu user.
    echo "REMOTE_MYSQL_USER = ${REMOTE_MYSQL_USER}"
    echo "REMOTE_MYSQL_PASS = ${REMOTE_MYSQL_PASS}"
    echo "REMOTE_MYSQL_DB   = ${REMOTE_MYSQL_DB}"
fi

exit