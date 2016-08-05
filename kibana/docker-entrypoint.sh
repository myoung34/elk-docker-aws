#!/bin/bash

set -e

# Add kibana as command if needed
if [[ "$1" == -* ]]; then
	set -- kibana "$@"
fi

# Run as user "kibana" if the command is "kibana"
if [ "$1" = 'kibana' ]; then
	if [ "$ELASTICSEARCH_URL" -o "$ELASTICSEARCH_PORT_9200_TCP" ]; then
		: ${ELASTICSEARCH_URL:='http://elasticsearch:9200'}
		sed -ri "s!^(\#\s*)?(elasticsearch\.url:).*!\2 '$ELASTICSEARCH_URL'!" /opt/kibana/config/kibana.yml
	else
		echo >&2 'warning: missing ELASTICSEARCH_PORT_9200_TCP or ELASTICSEARCH_URL'
		echo >&2 '  Did you forget to --link some-elasticsearch:elasticsearch'
		echo >&2 '  or -e ELASTICSEARCH_URL=http://some-elasticsearch:9200 ?'
		echo >&2
	fi

  [ ! -z "$ELASTICSEARCH_USERNAME" ] && sed -ri "s%^(\#\s*)?(elasticsearch\.username:).*%\2 '$ELASTICSEARCH_USERNAME'%" /opt/kibana/config/kibana.yml
  [ ! -z "$ELASTICSEARCH_PASSWORD" ] && sed -ri "s%^(\#\s*)?(elasticsearch\.password:).*%\2 '$ELASTICSEARCH_PASSWORD'%" /opt/kibana/config/kibana.yml
  [ ! -z "$SERVER_SSLCERT" ] && sed -ri "s%^(\#\s*)?(server\.ssl\.cert:).*%\2 '$SERVER_SSLCERT'%" /opt/kibana/config/kibana.yml
  [ ! -z "$SERVER_SSLKEY" ] && sed -ri "s%^(\#\s*)?(server\.ssl\.key:).*%\2 '$SERVER_SSLKEY'%" /opt/kibana/config/kibana.yml
  [ ! -z "$ELASTICSEARCH_SSLCERT" ] && sed -ri "s%^(\#\s*)?(elasticsearch\.ssl\.cert:).*%\2 '$ELASTICSEARCH_SSLCERT'%" /opt/kibana/config/kibana.yml
  [ ! -z "$ELASTICSEARCH_SSLKEY" ] && sed -ri "s%^(\#\s*)?(elasticsearch\.ssl\.key:).*%\2 '$ELASTICSEARCH_SSLKEY'%" /opt/kibana/config/kibana.yml
  [ ! -z "$ELASTICSEARCH_SSLCA" ] && sed -ri "s%^(\#\s*)?(elasticsearch\.ssl\.ca:).*%\2 '$ELASTICSEARCH_SSLCA'%" /opt/kibana/config/kibana.yml
  [ ! -z "$ELASTICSEARCH_SSLVERIFY" ] && sed -ri "s%^(\#\s*)?(elasticsearch\.ssl\.verify:).*%\2 '$ELASTICSEARCH_SSLVERIFY'%" /opt/kibana/config/kibana.yml
	
	set -- gosu kibana tini -- "$@"
fi

exec "$@"
