#!/bin/bash

set -o errexit
set -o nounset

source ./globals.sh
source ./functions.sh

# Run
if [ "$#" -eq 0 ]; then
    introduction
    auto_setup
    else

    for i in "$@"
    do
        case $i in
            # Help
            -h|--help)
                show_help
                ;;

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
            -r=*|--remote-host=*)
                REMOTE_HOST="${i#*=}"
                shift
                ;;

            -w=*|--remote-ssh-user=*)
                REMOTE_SSH_USER="${i#*=}"
                shift
                ;;

            -b=*|--remote-webroot=*)
                REMOTE_WEBROOT="${i#*=}"
                shift
                ;;

            -b=*|--remote-domain=*)
                REMOTE_DOMAIN="${i#*=}"
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
fi

# ===== Entry Point =====
# Check over the core variables that are necessary for the script to work.
# Will not check for MySQL passwords as it is possible to have
# a blank MySQL password.
if [[ -z $LOCAL_DIR || -z $LOCAL_MYSQL_USER || -z $REMOTE_HOST || -z $REMOTE_SSH_USER || -z $REMOTE_DOMAIN || -z $REMOTE_MYSQL_USER || -z $REMOTE_MYSQL_DB ]]; then

    echo -e "${RED}One or more core variables is undefined!${NONE}"
    echo -e "${RED}Run the program with the -h or --help flag${NONE}"
    echo -e "${RED}to see a full list of the necessary variables.${NONE}"

else
    echo
    main

    clean_up
fi

exit