#!/bin/bash

# Configure and deploy modules on a running Okapi.
# This script can be invoked with either the "start" or "stop" argument.

[ -f /etc/default/okapi-deploy ] && . /etc/default/okapi-deploy

if [ ! -x "$CURL" ] ; then
  echo "Unable to execute curl" 1>&2
  exit 126;
fi

if [ ! -x "$OKAPI_UNDEPLOY" ] ; then
  echo "Unable to execute okapi-undeploy script" 1>&2
  exit 126;
fi

if [ -f "${CONF_DIR}/okapi-deploy.conf" ] ; then
  . "${CONF_DIR}/okapi-deploy.conf";
else
  echo "Cannot locate okapi-deploy.conf" 1>&2
  exit 2;
fi

for i in $modules ; do
  if [ ! -f "${CONF_DIR}/deployment-descriptors/${i}.json" ] ; then
    echo "Cannot locate deployment descriptor for $i" 1>&2
    exit 2;
  fi
done
  

if [ "$1" = "start" ] ; then
  echo -n "Checking for Okapi..."
  OKAPI=0
  for i in {1..30} ; do
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
    # post Okapi environment variables
    for i in "${!okapi_env[@]}" ; do
      $CURL --output /dev/null --fail --silent -X POST -H "Content-Type: application/json" -d "{\"name\":\"${i}\",\"value\":\"${okapi_env[$i]}\"}" ${okapi_url}/_/env
      if [ "$?" = "0" ] ; then
        echo "Set Okapi environment variable $i"
      else
        echo "Failed set Okapi environment variable $i" 1>&2
        exit 1;
      fi
    done
    for i in $modules ; do
      $CURL --output /dev/null --fail --silent -X POST -H "Content-Type: application/json" -d @${CONF_DIR}/deployment-descriptors/${i}.json ${okapi_url}/_/deployment/modules
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
  for i in $module_ids ; do
    $OKAPI_UNDEPLOY $i $okapi_url
    if [ "$?" = "0" ] ; then
      echo "$i undeployed from $okapi_url";
    else
      echo "Failed to undeploy $i from $okapi_url" 1>&2
      exit 1;
    fi
  done
else
  echo "Usage: okapi-deploy.sh [start|stop]" 1>&2
  exit 1;
fi

exit 0
