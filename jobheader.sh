#!/bin/bash
#figure out amount of memory we really need by parsing config.json with jq
if [ "$(jq .comptprof -r config.json)" == "true" ]; then
    mem=64gb
    walltime=02:00:00
else
    mem=32gb
    walltime=01:30:00
fi

echo "#PBS -l nodes=1:ppn=4,vmem=$mem"
echo "#PBS -l walltime=$walltime"

