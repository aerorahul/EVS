#PBS -N jevs_cam_hireswarw_severe_prep
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A EVS-DEV
#PBS -l walltime=0:30:00
#PBS -l select=1:ncpus=1:mem=40GB
#PBS -l debug=true
#PBS -V


set -x

cd $PBS_O_WORKDIR


############################################################
# Load modules
############################################################


export model=evs
export NET=evs
export STEP=prep
export COMPONENT=cam
export RUN=atmos

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS
source $HOMEevs/versions/run.ver
module reset
module load prod_envir/${prod_envir_ver}

source $HOMEevs/modulefiles/$COMPONENT/${COMPONENT}_${STEP}.sh
export evs_ver=v1.0.0
evs_ver_2d=$(echo $evs_ver | cut -d'.' -f1-2)

export vhr=${vhr:-${vhr}}


############################################################
# For dev testing
############################################################
export envir=prod
export DATAROOT=/lfs/h2/emc/stmp/${USER}/evs_test/$envir/tmp
export KEEPDATA=YES
export VERIF_CASE=severe
export MODELNAME=hireswarw
export modsys=hiresw
export job=${PBS_JOBNAME:-jevs_${COMPONENT}_${MODELNAME}_${VERIF_CASE}_${STEP}_${vhr}}
export jobid=$job.${PBS_JOBID:-$$}
export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/$NET/$evs_ver_2d
export COMOUT=/lfs/h2/emc/vpppg/noscrub/$USER/$NET/$evs_ver_2d/$STEP/$COMPONENT
############################################################

export SENDMAIL=${SENDMAIL:-YES}
export SENDCOM=${SENDCOM:-YES}
export SENDECF=${SENDECF:-YES}
export SENDDBN=${SENDDBN:-YES}
export KEEPDATA=${KEEPDATA:-YES}

export maillist=${maillist:-'marcel.caron@noaa.gov,alicia.bentley@noaa.gov'}

if [ -z "$maillist" ]; then

   echo "maillist variable is not defined. Exiting without continuing."

else

   # CALL executable job script here
   $HOMEevs/jobs/JEVS_CAM_PREP

fi


######################################################################
# Purpose: This job preprocesses HiResW ARW data for use in
#          CAM severe verification jobs
######################################################################

