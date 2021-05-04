#!/usr/bin/env bash

#### Check if bosco_key.rsa exists in $HOME/.ssh ####

#### start bosco ####
#bosco_start

#### register nersc endpoint ####
bosco_cluster --platform RH6 --add $DONUT_USER@donut-submit01 slurm

#### stop bosco ####
#bosco_stop

#### Install Pegasus and the glite attributes ####
ssh -i $HOME/.ssh/bosco_key.rsa $DONUT_USER@donut-submit01 <<EOF
wget http://download.pegasus.isi.edu/pegasus/${PEGASUS_VERSION_NUM}/pegasus-binary-${PEGASUS_VERSION_NUM}-x86_64_rhel_7.tar.gz
tar -xzvf pegasus-binary-${PEGASUS_VERSION_NUM}-x86_64_rhel_7.tar.gz
rm -f pegasus-binary-${PEGASUS_VERSION_NUM}-x86_64_rhel_7.tar.gz
$DONUT_USER_HOME/pegasus-${PEGASUS_VERSION_NUM}/bin/pegasus-configure-glite $DONUT_USER_HOME/bosco/glite
sed -i "s/supported_lrms=.*/supported_lrms=slurm/" $DONUT_USER_HOME/bosco/glite/etc/batch_gahp.config
EOF

#### Install edited glite scripts ####
sftp -i $HOME/.ssh/bosco_key.rsa $DONUT_USER@donut-submit01 <<EOF
put /opt/slurm_cluster_patch/* $DONUT_USER_HOME/bosco/glite/bin
EOF
