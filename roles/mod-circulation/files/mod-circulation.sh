#!/bin/bash

# Configure and deploy mod-circulation on a running Okapi.
# This script can be invoked with either the "start" or "stop" argument.

[ -f /etc/default/mod-circulation ] && . /etc/default/mod-circulation

if [ ! -x "$CURL" ] ; then
  echo "Unable to execute curl" 1>&2
  exit 126;
fi

if [ ! -x "$OKAPI_UNDEPLOY" ] ; then
  echo "Unable to execute okapi-undeploy script" 1>&2
  exit 126;
fi

if [ -f "${CONF_DIR}/mod-circulation.conf" ] ; then
  . "${CONF_DIR}/mod-circulation.conf";
else
  echo "Cannot locate mod-circulation.conf" 1>&2
  exit 2;
fi

if [ ! -f "${CONF_DIR}/DeploymentDescriptor.json" ] ; then
  echo "Cannot locate DeploymentDescriptor.json" 1>&2
  exit 2;
fi
  

if [ "$1" = "start" ] ; then
  echo -n "Checking for Okapi..."
  OKAPI=0
  for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ; do
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
    echo -n "Checking for loan-storage..."
    LOAN_STORAGE=0
    for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ; do
      $CURL --output /dev/null --silent --get --fail ${okapi_url}/_/discovery/modules/loan-storage
      if [ "$?" = "0" ] ; then
        echo "OK"
        LOAN_STORAGE=1
        break;
      else
        echo -n "."
        sleep 1;
      fi
    done
    if [ "$LOAN_STORAGE" = "1" ] ; then
      $CURL --output /dev/null --fail --silent -X POST -H "Content-Type: application/json" -d @${CONF_DIR}/DeploymentDescriptor.json ${okapi_url}/_/deployment/modules
      if [ "$?" = "0" ] ; then
        echo "mod-circulation deployed to $okapi_url"
      else
        echo "Failed to deploy mod-circulation to $okapi_url" 1>&2
        exit 1;
      fi
    else
      echo "No loan-storage instance" 1>&2
    fi
  else
    echo "Unable to connect to $okapi_url" 1>&2
    exit 1;
  fi
elif [ "$1" = "stop" ] ; then
  $OKAPI_UNDEPLOY circulation $okapi_url
  if [ "$?" = "0" ] ; then
    echo "mod-circulation undeployed from $okapi_url";
  else
    echo "Failed to undeploy mod-circulation from $okapi_url" 1>&2
    exit 1;
  fi
else
  echo "Usage: mod-circulation.sh [start|stop]" 1>&2
  exit 1;
fi

exit 0
