#PBS -N jevs_mesoscale_sref_cloud_past90days_plots
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A EVS-DEV
#PBS -l walltime=00:30:00
#PBS -l place=vscatter,select=1:ncpus=112:mem=300GB
#PBS -l debug=true

set -x

export OMP_NUM_THREADS=1

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS

source $HOMEevs/versions/run.ver


export met_v=${met_ver:0:4}

export envir=prod

export NET=evs
export STEP=plots
export COMPONENT=mesoscale
export RUN=atmos
export VERIF_CASE=cloud
export MODELNAME=sref

module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/modulefiles/$COMPONENT/${COMPONENT}_${STEP}.sh
export evs_ver=v1.0.0
evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)

export KEEPDATA=YES
export SENDMAIL=YES
export SENDDBN=YES

export past_days=90

export run_mpi=yes
export valid_time=both

export COMIN=/lfs/h2/emc/vpppg/noscrub/${USER}/$NET/$evs_ver_2d
export COMOUT=/lfs/h2/emc/ptmp/${USER}/$NET/$evs_ver_2d/$STEP/$COMPONENT
export DATAROOT=/lfs/h2/emc/stmp/$USER/evs_test/$envir/tmp
export job=${PBS_JOBNAME:-jevs_${MODELNAME}_${VERIF_CASE}_${STEP}}
export jobid=$job.${PBS_JOBID:-$$}

${HOMEevs}/jobs/JEVS_MESOSCALE_PLOTS
