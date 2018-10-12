#!/bin/bash
#
# Create platform stripes-install.json and okapi-install.json module
# lists that can be used to deploy a platform via build-module-list
#


# requirements
type curl >/dev/null 2>&1 || { echo >&2 "curl is required but it's not installed"; exit 1; }
type jq >/dev/null 2>&1 || { echo >&2 "jq is required but it's not installed"; exit 1; }

usage() {
  cat << EOF
Usage: ${0##*/} -o OKAPI_URL -t TENANT -p /path/to/mod/descriptors --coreonly (Optional)
EOF
}

while [[ $# -gt 0 ]]
do
   key="$1"

   case $key in
      -o|--okapiurl)
         okapiUrl="$2"
         shift # past argument
         shift # past value
        ;;
      -t|--tenant)
         tenant="$2"
         shift # past argument
         shift # past value
         ;;
      -p|--path)
         mdPath="$2"
         shift # past argument
         shift # past argument
         ;;
      -c|--coreonly)
         coreOnly=true
         shift # past argument
         ;;
      -r|--releases-only)
         releasesOnly=true
         shift # past argument
         ;;
      *) 
         usage >&2
         exit 1 
         ;;
esac
done

if [[ -z "$okapiUrl" || -z "$tenant" || -z "$mdPath" ]]; then
    echo "Missing required option(s)"
    usage >&2
    exit 1
fi


modDescriptorList=$(ls $mdPath/*.json)

stripesInstallList="./stripes-install.json"
okapiInstallList="./okapi-install.json"
installList="/tmp/install.json"

# These need to be added manually. 
includeModulesCore="mod-codex-inventory"
includeModulesAll="$includeModulesCore mod-rtac"
excludeModules="folio_stripes folio_eslint-config-stripes folio_react-intl-safe-html folio_react-big-calendar"

if [ "$coreOnly" = true ]; then
  includeModules="$includeModulesCore"
else
  includeModules="$includeModulesAll"
fi

if [ "$releasesOnly" = true ]; then
  installOpts="simulate=true&preRelease=false"
else
  installOpts="simulate=true&preRelease=true"
fi


# Initialize module list
echo "[" > $installList

# Add Stripes modules to $installList
for modDescriptor in $modDescriptorList 
do
   include=true
   id=$(jq -r .id $modDescriptor)
   for ex in $excludeModules
   do 
     if [[ "$id" =~ ${ex}-[0-9]+.* ]]; then
       include=false
     fi
   done

   if [[ "$include" = true ]]; then
     echo "{ \"id\":\"${id}\",\"action\":\"enable\"}," >> $installList
   fi
done

# Add $includeModules to $installList
for mod in $includeModules
do
   echo "{ \"id\":\"${mod}\",\"action\":\"enable\"}," >> $installList
done

# end module list
sed -i -e '$s/,//2' $installList
echo "]" >> $installList


# Get all module deps from Okapi
status=$(curl -s -w "%{http_code}" -o /tmp/okapi_output -X POST \
              -H 'Content-type: application/json' \
              -d @${installList} \
               ${okapiUrl}/_/proxy/tenants/${tenant}/install?${installOpts})

if [[ ! $status =~ ^20[0|1]$ ]]; then
   echo "HTTP status error: $status" >>/dev/stderr
   cat /tmp/okapi_output >> /dev/stderr
   exit 1
fi


# prepare final list of backend modules to enable
okapiList=$(jq -r '.[].id' /tmp/okapi_output | egrep -v '^folio_')
stripesList=$(jq -r '.[].id' /tmp/okapi_output | egrep '^folio_') 
rm /tmp/okapi_output

# Initialize Okapi module list (backend modules)
echo "[" > $okapiInstallList

for id in $okapiList
do
  echo "{ \"id\":\"${id}\",\"action\":\"enable\"}," >> $okapiInstallList
done

rm -f $okapiList

# end Okapi module list
sed -i -e '$s/,//2' $okapiInstallList
echo "]" >> $okapiInstallList

# Initialize Stripes module list
echo "[" > $stripesInstallList

for id in $stripesList
do
  echo "{ \"id\":\"${id}\",\"action\":\"enable\"}," >> $stripesInstallList
done

rm -f $stripesList

# end Stripes module list
sed -i -e '$s/,//2' $stripesInstallList
echo "]" >> $stripesInstallList

cat $stripesInstallList
cat $okapiInstallList


