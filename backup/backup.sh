#!/bin/bash

BACKUP_DIR="/data/backup"

usage() {
  MESSAGE=$1
  echo "Error: ${MESSAGE}"
  echo ""
  echo "Usage: backup [ -B | --backup-dir directory ]
              [ -p | --project project ]"
  exit 2
}

PARSED_ARGUMENTS=$(getopt -a -n argument -o B:p: --long backup-dir:,project: -- "$@")

VALID_ARGUMENTS=$?

if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage "No arguments passed"
fi

eval set -- "$PARSED_ARGUMENTS"
while :; do
  case "$1" in
  -B | --backup-dir)
    BACKUP_DIR="$2"
    shift 2
    ;;
  -p | --project)
    COMPOSE_PROJECT_NAME="$2"
    shift 2
    ;;
  --)
    shift
    break
    ;;
  *)
    echo "Opção $1 não reconhecida."
    usage
    ;;
  esac
done

if [ ! "$BACKUP_DIR" ]; then
  usage "Backup directory not specified"
fi

if [ ! "$COMPOSE_PROJECT_NAME" ]; then
  usage "Project not specified"
fi

DATE=$(date +%d-%m-%Y-%H-%M)

echo ""
echo "*********************"
echo "* Backup SatAlertas *"
echo "*********************"
echo ""

if test -d "/var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_satalertas_documents_vol/_data/"; then
    mkdir -vp ${BACKUP_DIR}/${COMPOSE_PROJECT_NAME}/satalertas

    cd /var/lib/docker/volumes/${COMPOSE_PROJECT_NAME}_satalertas_documents_vol/_data/ || exit

    tar cvf - *.pdf | gzip -9 - > ${BACKUP_DIR}/${COMPOSE_PROJECT_NAME}/satalertas/satalertas_documents-${DATE}.tar.gz
fi
