#!/bin/bash 

# Parse the json array returned by stripes-cli into individual
# json files that can be POSTed to Okapi one at a time. 
# Optional argument: '-o OUTPUT/DIR'

usage() {
  cat << EOF
Usage: ${0##*/} -o path/to/output (optional)
EOF
}


while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    -o|--outputdir)
       outputdir="$2"
       shift # past argument
       shift # past value
       ;;
    -s|--strict)
       strict=true
       shift
       ;;
    *) 
       usage >&2
       exit 1
       ;;
  esac
done

if [ -n "$outputdir" ]; then
  mkdir -p $outputdir
else
  outputdir='.'
fi

if [[ "$strict" == true ]]; then
  stripescliCmd=$(stripes mod descriptor --configFile stripes.config.js --full --strict)
else
  stripescliCmd=$(stripes mod descriptor --configFile stripes.config.js --full)
fi

descriptors=$(echo ${stripescliCmd} | jq -r '.[] | @base64')

for d in $descriptors
do
  getId() {
    echo ${d} | base64 --decode | jq -r ${1}
  }
  id=$(getId '.id')
  echo ${d} | base64 --decode > ${outputdir}/${id}.json
done


