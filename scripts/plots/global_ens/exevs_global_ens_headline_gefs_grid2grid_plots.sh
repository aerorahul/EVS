#!/bin/ksh
#****************************************************************************************
# Purpose:  1. Setup the environment parameter for running GEFS headline plotting script
#           2. Run plotting script $USHevs/global_ens/evs_global_ens_headline_plot.sh
#  
#  Note: 1. The headline score needs the stat files over 0ne year + 17 days 
#           (this year + next 17 days of Jan) 
#        2. This job is run on Jan 17 of each year                 
#  
# Log History:  11/17/2021 Binbin Zhou  
#**********************************************************************
set -x
export run_mpi=${run_mpi:-'yes'}

this_year=${VDATE:0:4}
past=`$NDATE -8760 ${VDATE}01`
last_year=${past:0:4} 

mm=${VDATE:4:2}
dd=${VDATE:6:2}

if [ $mm = 01 ] && [ $dd = 17 ] ; then
  run_entire_year=yes
else
  run_entire_year=no
  last_year=$this_year
fi 

export PLOT_CONF=$PARMevs/metplus_config/$STEP/$COMPONENT/headline_grid2grid
$USHevs/global_ens/evs_global_ens_headline_plot.sh $last_year $this_year 
export err=$?; err_chk

tar -cvf evs.plots.${COMPONENT}.${RUN}.${MODELNAME}.${VERIF_CASE}.v${VDATE}.tar evs.global_ens*.png

if [ $SENDCOM = YES ]; then
    cpreq evs.plots.${COMPONENT}.${RUN}.${MODELNAME}.${VERIF_CASE}.v${VDATE}.tar $COMOUT/.
fi

if [ $SENDDBN = YES ]; then 
    $DBNROOT/bin/dbn_alert MODEL EVS_RZDM $job $COMOUT/evs.plots.${COMPONENT}.${RUN}.${MODELNAME}.${VERIF_CASE}.v${VDATE}.tar
fi
