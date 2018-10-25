#!/bin/bash

#figure out amount of memory we really need by parsing config.json with jq
if [ "$(jq .do_tprof -r config.json)" == "true" ]; then
    mem=64gb
else
    mem=32gb
fi

#generate main
cat <<EOF > _main
#!/bin/bash
#PBS -l nodes=1:ppn=4,vmem=$mem
#PBS -l walltime=01:00:00
#PBS -N bl-ntwrkmts

if [ -d $TMPDIR ]; then
    echo "using TMPDIR $TMPDIR for SINGULARITY_LOCALCACHEDIR"
    export SINGULARITY_LOCALCACHEDIR=\$TMPDIR
fi

time singularity exec -e docker://brainlife/mcr:neurodebian1604-r2017a ./compiled/main
echo "Network Pipeline Complete"
if [ ! -s output/pconn.mat ];
then
    echo "output missing"
    exit 1
fi
EOF

#submit to batch scheduler
which sbatch && sbatch --parsable -o "slurm-%j.log" -e "slurm-%j.err" _main > jobid
which qsub && qsub -d $PWD -V -o \$PBS_JOBID.log -e \$PBS_JOBID.err _main > jobid


