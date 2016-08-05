#!/bin/bash

set -e

params=""
if [ "$1" = 'curator' ]; then

  [ ! -z "$SSL_ENABLED" ] && params='--use_ssl --ssl-no-validate'
  [ ! -z "$ELASTICSEARCH_USER_PASS" ] && params="${params} --http_auth ${ELASTICSEARCH_USER_PASS}"
  [ ! -z "$ELASTICSEARCH_HOST" ] && params="${params} --host ${ELASTICSEARCH_HOST}"
  shift
	set -- "$@"
  $(echo curator "${params}" "$@")
fi

if [ "$1" = 'bash' ]; then
  shift
	set -- "$@"
  eval "$@"
fi

