#!/bin/bash

# Configure and deploy mod-metadata on a running Okapi.
# This script can be invoked with either the "start" or "stop" argument.

[ -f /etc/default/mod-metadata ] && . /etc/default/mod-metadata

if [ ! -x "$CURL" ] ; then
  echo "Unable to execute curl" 1>&2
  exit 126;
fi

if [ ! -x "$OKAPI_UNDEPLOY" ] ; then
  echo "Unable to execute okapi-undeploy script" 1>&2
  exit 126;
fi

if [ -f "${CONF_DIR}/mod-metadata.conf" ] ; then
  . "${CONF_DIR}/mod-metadata.conf";
else
  echo "Cannot locate mod-metadata.conf" 1>&2
  exit 2;
fi

for i in "inventory-storage" "inventory" ; do
  if [ ! -f "${CONF_DIR}/DeploymentDescriptor_${i}.json" ] ; then
    echo "Cannot locate DeploymentDescriptor_${i}.json" 1>&2
    exit 2;
  fi
done
  

if [ "$1" = "start" ] ; then
  echo -n "Checking for Okapi..."
  OKAPI=0
  for i in 1 2 3 4 5 ; do
    $CURL --output /dev/null --silent --get --fail ${okapi_url}/_/proxy/modules
    if [ "$?" = "0" ] ; then
      echo "OK"
      OKAPI=1
      break;
    else
      echo -n "."
      sleep 1;
    fi
  done
  if [ "$OKAPI" = "1" ] ; then
    for i in "inventory-storage" "inventory" ; do
      $CURL --output /dev/null --fail --silent -X POST -H "Content-Type: application/json" -d @${CONF_DIR}/DeploymentDescriptor_${i}.json ${okapi_url}/_/discovery/modules
      if [ "$?" = "0" ] ; then
        echo "$i deployed to $okapi_url"
      else
        echo "Failed to deploy $i to $okapi_url" 1>&2
        exit 1;
      fi
    done
  else
    echo "Unable to connect to $okapi_url" 1>&2
    exit 1;
  fi
elif [ "$1" = "stop" ] ; then
  for i in "inventory-storage" "inventory" ; do
    $OKAPI_UNDEPLOY $i $okapi_url
    if [ "$?" = "0" ] ; then
      echo "$i undeployed from $okapi_url";
    else
      echo "Failed to undeploy $i from $okapi_url" 1>&2
      exit 1;
    fi
  done
else
  echo "Usage: mod-metadata.sh [start|stop]" 1>&2
  exit 1;
fi

exit 0
